# == Schema Information
# Schema version: 20090624205124
#
# Table name: version
#
#  id            :integer         not null, primary key
#  package_id    :integer
#  name          :string(255)
#  title         :string(255)
#  description   :text
#  license       :text
#  version       :string(255)
#  depends       :text
#  suggests      :text
#  author        :text
#  url           :string(255)
#  date          :date
#  readme        :text
#  changelog     :text
#  news          :text
#  diff          :text
#  created_at    :datetime
#  updated_at    :datetime
#  maintainer_id :integer
#  imports       :text
#  enhances      :text
#  priority      :string(255)
#

class Version < ActiveRecord::Base

  has_many :reviews

  belongs_to :package
  belongs_to :maintainer, :class_name => "Author"

  has_and_belongs_to_many :required_packages, :class_name => "Package",
                          :association_foreign_key => "required_package_id",
                          :join_table => "required_package_version"
  alias :depends :required_packages

  has_and_belongs_to_many :enhanced_packages, :class_name => "Package",
                          :association_foreign_key => "enhanced_package_id",
                          :join_table => "enhanced_package_version"
  alias :enhances :enhanced_packages

  has_and_belongs_to_many :suggested_packages, :class_name => "Package",
                          :association_foreign_key => "suggested_package_id",
                          :join_table => "suggested_package_version"
  alias :suggests :suggested_packages

  fires :new_version, :on                => :create,
                      :secondary_subject => :package

  validates_existence_of :package_id
  validates_presence_of :version
  validates_length_of :name, :in => 2..255
  validates_length_of :version, :in => 1..25
  validates_length_of :title, :in => 0..255, :allow_nil => true
  validates_length_of :url, :in => 0..255, :allow_nil => true

  def <=>(other)
    self.name.downcase <=> other.name.downcase
  end

  def to_s
    version
  end

  def urls
    (url.split(",") rescue []).map(&:strip) + [cran_url]
  end

  def cran_url
    "http://cran.r-project.org/web/packages/#{name}"
  end

  def vname
    name + "_" + version
  end

  def reverse_depends
    Version.find(:all, :include => :package, :conditions =>
                 ["id IN (SELECT version_id FROM required_package_version WHERE required_package_id = ?)",
                  self.package.id]).sort.map(&:package)
  end

  def reverse_enhances
    Version.find(:all, :include => :package, :conditions =>
                 ["id IN (SELECT version_id FROM enhanced_package_version WHERE enhanced_package_id = ?)",
                  self.package.id]).sort.map(&:package)
  end

  def reverse_suggests
    Version.find(:all, :include => :package, :conditions =>
                 ["id IN (SELECT version_id FROM suggested_package_version WHERE suggested_package_id = ?)",
                  self.package.id]).sort.map(&:package)
  end

  def parse_depends
    parse_requirements(attributes["depends"])
  end

  def parse_suggests
    parse_requirements(attributes["suggests"])
  end

  def parse_enhances
    parse_requirements(attributes["enhances"])
  end

  def parse_imports
    parse_requirements(attributes["imports"])
  end
  alias :imports :parse_imports

  # This runs from lib/tasks/cache.rake. Not sure if this is still needed.
  def cache_maintainer!
    author = Author.new_from_string(attributes["maintainer"])

    self.maintainer = author
    save
  end

  private
  def parse_requirements(reqs)
    reqs.split(",").map{|full| full.split(" ")[0]}.map do |name|
      Package.find_by_name name
    end.compact.sort rescue []
  end

end
