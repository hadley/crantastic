#!/usr/bin/env ruby

# Required Ruby gems:
# * atom-tools
# * Chrononaut-treetop-dcf
#
# Required R packages:
# * digest
# * RCurl
# * rjson

require "rubygems"
require "atom/feed"
require "dcf"
require "open-uri"

f = Atom::Feed.new("http://feeds.feedburner.com/NewPackageVersionsOnCrantastic")

f.update!

unless File.exists?("last_id")
  File.open("last_id", "w") { |f| f.print "0" }
end

last_id = File.open("last_id", "r")

last_id = last_id.read.to_i

# "tag:crantastic.org,2005:Version/4156"
to_update = f.entries.to_a.find_all { |e| e.id.scan(/\d+\Z/)[0].to_i > last_id }

`sudo apt-get update`

unless to_update.empty?
  to_update.reverse.each do |pkg|
    # The main package title. Can be a package bundle.
    pkg_title = pkg.title.to_s.split[0]
    id = pkg.id.scan(/\d+\Z/)[0].to_i

    description = Dcf.parse(open("http://cran.r-project.org/web/packages/#{pkg_title}/DESCRIPTION").read)[0]
    if description.has_key? "Contains"
      packages = description["Contains"].split
    else
      packages = [pkg_title]
    end

    deb_pkg_name = "r-cran-" + pkg_title.downcase
    if `apt-cache search --names-only #{deb_pkg_name}$` == ""
      File.open("skiplog", "a") { |f| f.puts("#{pkg_title} was not found by apt") }
      next
    end

    puts "Installing #{deb_pkg_name}"

    `sudo apt-get install -y #{deb_pkg_name}`

    packages.each do |title|
      puts "./crantastic-store-functions.R #{pkg_title} #{title} #{id}"
      `sudo ./crantastic-store-functions.R #{pkg_title} #{title} #{id}`
      exit_status = $?.exitstatus
      puts "Exit status: #{exit_status}"

      if exit_status != 0
        File.open("faillog", "a") { |f| f.puts("#{pkg_title} (#{title}) failed") }
        exit 1
      end
    end
    File.open("last_id", "w") { |f| f.puts(id) }
  end
end
