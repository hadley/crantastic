require "fileutils"
require "digest/md5"
require "cran"
require "dcf"
require "twitter"

module Crantastic

  module Resources

    class Package < ActiveResource::Base
      self.site = "http://crantastic:#{ENV['CRANTASTIC_PASSWORD']}@#{APP_CONFIG[:site_domain]}/"

      def self.find_by_name(name)
        self.find(name)
      rescue ActiveResource::ResourceNotFound
        nil
      end

      def self.all
        self.find(:all, :from => :all)
      end
    end

    class Version < ActiveResource::Base
      self.site = "http://crantastic:#{ENV['CRANTASTIC_PASSWORD']}@#{APP_CONFIG[:site_domain]}/"
    end

    class Author < ActiveResource::Base
      self.site = "http://crantastic:#{ENV['CRANTASTIC_PASSWORD']}@#{APP_CONFIG[:site_domain]}/"

      def self.find_by_name(name)
        self.find(:first, :params => { :name => name })
      rescue ActiveResource::ResourceNotFound
        nil
      end

      def self.find_by_email(email)
        self.find(:first, :params => { :email => email })
      rescue ActiveResource::ResourceNotFound
        nil
      end

      def self.find_or_create(name = nil, email = nil)
        author = email.nil? ? nil : Author.find_by_email(email)
        author = self.find_by_name(name) unless author
        author.nil? ? self.create(:name => name, :email => email) : author
      end

      # Input is mainly from the "Maintainer"-field in CRAN's DESCRIPTION
      # files. E.g. "Christian Buchta <christian.buchta at wu-wien.ac.at>".
      # E-mail address is not guaranteed to be valid, as can be seen above.
      #
      # @return [Author] An Author-object corresponding to the input string
      def self.new_from_string(string)
        name, email = string.mb_chars.split(/[<>]/).map(&:strip)
        if name =~ /@/
          email = name
          name = nil
        end

        return self.find_by_name("Unknown") if name.blank?

        email.downcase! unless email.blank? # NOTE: is this necessary?

        Author.find_or_create(name, email)
      end
    end

  end

  class UpdatePackages
    def start
      Log.log!("Starting task: UpdatePackages")

      `curl -s http://cran.r-project.org/src/contrib/PACKAGES.gz -o tmp/PACKAGES.gz`
      `gunzip -f tmp/PACKAGES.gz`
      packages = File.read("tmp/PACKAGES")
      digest = Digest::MD5.hexdigest(packages)
      unless File.exists?("tmp/PACKAGES.digest")
        File.open("tmp/PACKAGES.digest", "w") { |f| f.print "" }
      end
      prev_digest = File.read("tmp/PACKAGES.digest")

      if digest == prev_digest # No changes since last check
        Log.log!("No changes to the MD5 digest of the PACKAGES file - exiting")
        Log.log!("Finished task: UpdatePackages")
        return true
      end

      crantastic_pkgs = Resources::Package.all

      packages.split("\n\n").each do |entry|
        package = entry.scan(/Package: (.+)/)[0][0]
        version = entry.scan(/Version: (.+)/)[0][0]

        next if package == "orientlib" && version == "0.10.1" # known bad entry

        cur = crantastic_pkgs.find { |pkg| pkg.name == package }
        if cur
          if cur.latest_version.nil?
            Log.log_and_report! "Problem with package #{package}: latest_version missing!"
          elsif cur.latest_version.version != version
            Log.log!("Updating package: #{package} (#{version})")
            add_version_to_db(CRAN::CranPackage.new(package, version), cur.id)
          end
        else
          Log.log!("New package: #{package} (#{version})")
          # ActiveResource doesn't support transactions so this is a bit scary
          pkg = Resources::Package.create(:name => package)
          begin
            ver = add_version_to_db(CRAN::CranPackage.new(package, version), pkg.id)
            if ver.blank?
              Log.log_and_report! "Problem with package #{package}: could not store #{version}"
              pkg.destroy
            end
          rescue Exception => e
            pkg.destroy
            throw e
          end
        end
      end

      File.open("tmp/PACKAGES.digest", "w") do |f|
        f.print Digest::MD5.hexdigest(File.read("tmp/PACKAGES"))
      end
      File.delete("tmp/PACKAGES")

      Log.log!("Finished task: UpdatePackages")
      return true
    end

    def add_version_to_db(pkg, crantastic_package_id)
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
      data[:maintainer_id] = Resources::Author.new_from_string(data[:maintainer]).id
      data.delete(:maintainer)

      data[:package_id] = crantastic_package_id
      version = Resources::Version.create(data)
      FileUtils.rm_rf(pkgdir)
      return version
    rescue OpenURI::HTTPError, SocketError, URI::InvalidURIError, Timeout::Error
      Log.log_and_report! "Problem downloading #{pkg}, skipping to next pkg"
    rescue Exception => e
      Log.log_and_report! "Unknown problem when adding #{pkg}: #{e}"
      pkg.destroy
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

  # NOTE: This still runs on Heroku (and there is no reason why it shouldn't)
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

  class Tweet
    def initialize
      @daily = DailyDigest.new(Time.zone.now.strftime("%Y%m%d"))
      httpauth = Twitter::HTTPAuth.new("cranatic", ENV['TWITTER_PASSWORD'])
      @client = Twitter::Base.new(httpauth)
      Twitter::HTTPAuth.base_uri "http://identi.ca/api"
    end

    def start
      Log.log!("Starting task: Tweet")
      tweets = @daily.tweets
      @client.update(tweets[:packages]) unless tweets[:packages].blank?
      @client.update(tweets[:versions]) unless tweets[:versions].blank?
      Log.log!("Finished task: Tweet")
    end
  end

  class CreateWeeklyDigest
    def start
      Log.log!("Starting task: CreateWeeklyDigest")
      WeeklyDigest.create!
      Log.log!("Finished task: CreateWeeklyDigest")
    end
  end

  class Maintenance
    class << self
      # If a version somehow is missing, this can be used to add it. Note that
      # currently only the latest version of a package can be added with this
      # method.
      #
      # @param [String] package
      # @param [String] version
      # @param [Fixnum] pkg_id The package id in the crantastic database
      def force_version(package, version, pkg_id)
        upd = UpdatePackages.new
        upd.add_version_to_db(CRAN::CranPackage.new(package, version), pkg_id)
      end
    end
  end

end
