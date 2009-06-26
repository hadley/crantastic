require "fileutils"
require "cran"
require "dcf"

module Crantastic

  class UpdatePackages
    def start
      Log.log!("Starting cron task: UpdatePackages")
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
          end
        else
          Log.log!("New package: #{package} (#{version})")
          Package.transaction do
            Package.create!(:name => package) # Start by creating the package entry
            add_version_to_db(CRAN::CranPackage.new(package, version))
          end
        end
      end
      Log.log!("Cron task finished.")
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
                :maintainer, :date, :url, :depends, :suggests, :imports]
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

      # Find or create maintainer
      data[:maintainer] = Author.new_from_string(data[:maintainer])

      data[:package] = Package.find_by_name(pkg.name)
      Version.create!(data)
      FileUtils.rm_rf(pkgdir)
    rescue OpenURI::HTTPError, SocketError, URI::InvalidURIError
      Log.log! "Problem downloading #{pkg}, skipping to next pkg"
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
      views = CRAN::TaskViews.new(open("http://cran.r-project.org/web/views/index.html").read)
      views.each do |v|
        # TODO: check view version, simply skip if it hasnt been updated.
        # If it has changed, we have to look through all previously tagged
        # packages for this view, to check if they have been removed from te view.
        view = CRAN::TaskView.new(open("http://cran.r-project.org/web/views/#{v}.ctv").read)
        tag = Tag.find(:first, :conditions => { :name => view.name,
                                                :task_view => true })
        view.packagelist.each do |pkg|
          # 146 = crantastic user
          conds = {
            :package_id => Package.find_by_name(pkg).id,
            :user_id => 146,
            :tag_id => tag.id
          }
          Tagging.create!(conds) unless Tagging.find(:first, :conditions => conds)
        end
      end
    end
  end

end
