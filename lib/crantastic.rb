require "fileutils"
require "cran"
require "dcf"
require "twitter"

module Crantastic

  class UpdatePackages
    def start
      Log.log!("Starting task: UpdatePackages")

      oauth = Twitter::OAuth.new(ENV['TWITTER_TOKEN'], ENV['TWITTER_SECRET'])
      oauth.authorize_from_access(ENV['TWITTER_ATOKEN'], ENV['TWITTER_ASECRET'])
      twitter_client = Twitter::Base.new(oauth)

      `curl -s http://cran.r-project.org/src/contrib/PACKAGES.gz -o tmp/PACKAGES.gz`
      `gunzip -f tmp/PACKAGES.gz`
      packages = File.read("tmp/PACKAGES")
      packages.split("\n\n").each do |entry|
        package = entry.scan(/Package: (.+)/)[0][0]
        version = entry.scan(/Version: (.+)/)[0][0]

        next if package == "orientlib" && version == "0.10.1" # known bad entry

        cur = Package.find_by_name(package)
        if cur
          if cur.latest.version != version
            Log.log!("Updating package: #{package} (#{version})")
            add_version_to_db(CRAN::CranPackage.new(package, version))

            twitter_client.update("#rstats #{package} upgraded to version #{version}: " +
                                  "http://crantastic.org/packages/#{package}")
          end
        else
          Log.log!("New package: #{package} (#{version})")
          Package.transaction do
            Package.create!(:name => package) # Start by creating the package entry
            add_version_to_db(CRAN::CranPackage.new(package, version))
          end

          #twitter_client.update("#rstats #{package} released: " +
          #                      "http://crantastic.org/packages/#{package}")
        end
      end
      File.delete("tmp/PACKAGES")
      Log.log!("Finished task: UpdatePackages")
      return true
    end

    def add_version_to_db(pkg)
      filename = "#{pkg.name}_#{pkg.version}.tar.gz"
      `curl -s "http://cran.r-project.org/src/contrib/#{pkg.name}_#{pkg.version}.tar.gz" -o tmp/#{filename}`
      `tar -C tmp -zxvf tmp/#{filename}; rm tmp/#{filename}`

      pkgdir = File.join(RAILS_ROOT, "/tmp/#{pkg.name}/")

      description = Dcf.parse(File.read(pkgdir + "DESCRIPTION"))
      throw Exception.new("Couldn't parse DESCRIPTION for #{pkg.name}. " +
                          "Look at http://cran.r-project.org/web/packages/#{pkg.name}/DESCRIPTION " +
                          "for clues.") if description.nil?
      data = description.first
      data = data.downcase_keys.symbolize_keys

      fields = [:title, :license, :description, :author, :enhances, :priority,
                :maintainer, :date, :url, :depends, :suggests, :imports,
                :"date/publication", :packaged ]
      data.delete_if { |k,v| !fields.include?(k) } # Remove unwanted fields

      data.merge!(read_from_files(pkgdir, %w(README NEWS)))
      # No standard for what the changelog file should be called so we try a bunch
      data[:changelog] = read_from_files(pkgdir, %w(CHANGELOG ChangeLog Changes)).values.first

      data.merge!(pkg.to_hash)

      # We must convert every value to UTF-8
      data = data.inject({}) { |b, (k,v)| b[k] = v.latin1_to_utf8 if v; b }

      begin
        data[:date] = Date.parse(data[:date])
      rescue
        data[:date] = nil
      end

      # Store date added to CRAN, or alternatively package date
      # (People often forget to update the regular date field on release and it
      # can be years out of date)
      data[:publicized_or_packaged] = nil
      if data[:"date/publication"]
        data[:publicized_or_packaged] = DateTime.parse(data[:"date/publication"])
      elsif data[:packaged]
        data[:publicized_or_packaged] = DateTime.parse(data[:packaged])
      end
      data.delete(:"date/publication")
      data.delete(:packaged)

      # Find or create maintainer
      data[:maintainer] = Author.new_from_string(data[:maintainer])

      data[:package] = Package.find_by_name(pkg.name)
      Version.create!(data)
      FileUtils.rm_rf(pkgdir)
    rescue OpenURI::HTTPError, SocketError, URI::InvalidURIError, Timeout::Error
      Log.log_and_report! "Problem downloading #{pkg}, skipping to next pkg"
    end

    def read_from_files(pkgdir, files)
      data = {}
      files.each do |f|
        if File.exists?(pkgdir + f)
          data[f.downcase.to_sym] = File.read(pkgdir + f)
        else
          if File.exists?(pkgdir + "inst/" + f)
            data[f.downcase.to_sym] = File.read(pkgdir + "inst/" + f)
          end
        end
      end
      data
    end
  end

  class UpdateTaskViews
    def start
      Log.log!("Starting task: UpdateTaskViews")
      views = CRAN::TaskViews.new(open("http://cran.r-project.org/web/views/index.html").read)
      views.each do |v|

        # NOTE: Currently this script does not consider the possibility that an
        # entire task view could get deleted/removed from CRAN.
        view = CRAN::TaskView.new(open("http://cran.r-project.org/web/views/#{v}.ctv").read)
        tag = TaskView.find_by_name(view.name)

        if tag
          if tag.version != view.version # View has been updated
            Tagging.transaction do
              Log.log! "Updating TaskView: #{view.name}"
              tag.update_version(view.version)

              existing_packages = tag.packages.map { |pkg| pkg.name }

              view.packagelist.each do |pkg|
                next if existing_packages.include?(pkg) # Already tagged
                Log.log! "Tagging #{pkg}"
                conds = {
                  :package_id => Package.find_by_name(pkg).id,
                  :user_id => 146, # The crantastic system user
                  :tag_id => tag.id
                }
                Tagging.create!(conds)
              end

              # Remove task view taggings for packages that has been removed from
              # the task view.
              (existing_packages - view.packagelist).each do |removed_package|
                Log.log! "Removed: #{removed_package}"
                Tagging.delete_all(["package_id = ? AND tag_id = ?",
                                    Package.find_by_name(removed_package).id, tag.id])
              end
            end
          else
            # No update for this task view, silently skipping.
          end

        else # Adding new task view
          Log.log! "New TaskView: #{view.name}"
          Tagging.transaction do
            tag = TaskView.create!(:name => view.name)
            view.packagelist.each do |pkg|
              conds = {
                :package_id => Package.find_by_name(pkg).id,
                :user_id => 146, # The crantastic system user
                :tag_id => tag.id
              }
              Tagging.create!(conds)
            end
          end
        end
      end
      Log.log!("Finished task: UpdateTaskViews")
      return true
    end
  end

end
