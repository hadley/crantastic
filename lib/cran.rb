require "yaml"
require "zlib"
require "fileutils"
require "open-uri"
require "dcf"

module CRAN

  # Simple struct for one CRAN package
  class Package < Struct.new(:name, :version)
    def to_s
      "#{name} (#{version})"
    end

    def to_hash
      { :name => name, :version => version }
    end

    def <=>(other)
      self.name <=> other.name
    end
  end

  # Enumerable list of CRAN packages.
  class Packages
    include Enumerable

    # @param [String] location Location of the Package data file. Expected to be gzipped.
    def initialize(location)
      @packages = []
      Dcf.parse(Zlib::GzipReader.new(open(location)).read).each do |pkg|
        @packages << CRAN::Package.new(pkg["Package"], pkg["Version"])
      end
    end

    def each
      @packages.each { |i| yield i }
    end

    def [](i)
      @packages[i]
    end
  end

end
