# == Schema Information
#
# Table name: version
#
#  id                     :integer(4)      not null, primary key
#  package_id             :integer(4)
#  name                   :string(255)
#  title                  :string(255)
#  description            :text
#  license                :text
#  version                :string(255)
#  depends                :text
#  suggests               :text
#  author                 :text
#  url                    :string(255)
#  date                   :date
#  readme                 :text
#  changelog              :text
#  news                   :text
#  diff                   :text
#  created_at             :datetime
#  updated_at             :datetime
#  maintainer_id          :integer(4)
#  imports                :text
#  enhances               :text
#  priority               :string(255)
#  publicized_or_packaged :datetime
#  version_changes        :text
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

  serialize :version_changes, Hash

  named_scope :recent, :include => :package,
                       :order => "created_at DESC",
                       :conditions => "created_at IS NOT NULL",
                       :limit => 50

  validates_existence_of :package_id
  validates_presence_of :version
  validates_uniqueness_of :version, :scope => :package_id
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

  # The CRAN package field is singular, we add a pluralised alias
  def authors
    author
  end

  # For now this just stores changes from the previous version
  def serialize_data
    return unless self.version_changes.nil? && previous

    db = CouchRest.database("http://208.78.99.54:5984/packages")
    current = db.get(vname)
    prev = db.get(previous.vname)

    current_functions = current["function_hashes"].keys
    prev_functions = prev["function_hashes"].keys

    changes = {}
    changes[:removed] = (prev_functions - current_functions).sort
    changes[:added]   = (current_functions - prev_functions).sort
    changes[:changed] = []

    current_functions.each do |f|
      changes[:changed] << f if current["function_hashes"][f] != prev["function_hashes"][f]
    end
    changes[:changed].sort!

    self.version_changes = changes

  rescue RestClient::ResourceNotFound
    self.version_changes = {}
  ensure
    save!
  end

  # Prefer publication/package date over the regular date field
  # @return [Date, DateTime]
  def date
    self.publicized_or_packaged || super
  end

  def uses
    (self.depends + self.imports).sort
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
    reverse("required_package")
  end

  def reverse_enhances
    reverse("enhanced_package")
  end

  def reverse_suggests
    reverse("suggested_package")
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

  def parse_authors
    author.split(",").map { |name| Author.new_from_string(name.strip) } rescue []
  end

  def as_json(options)
    { :type => "software",
      :id => name + "_" + version,
      :title => name,
      :version => version,
      :authors => author,
      :maintainer => maintainer,
      :keywords => package.tags.map{|t| t.name},
      :description => description
    }
  end

  # Finds the previous version
  # @return [Version]
  def previous
    Version.find(:last, :conditions => ["package_id = ? AND id < ?",
                                        package_id, id])
  end

  private

  def parse_requirements(reqs)
    reqs.split(",").map{|full| full.split(" ")[0]}.map do |name|
      Package.find_by_name name
    end.compact.sort rescue []
  end

  def reverse(key)
    Version.find(:all, :include => :package, :conditions =>
                 ["id IN (SELECT version_id FROM #{key}_version WHERE #{key}_id = ?)",
                  self.package.id]).sort.map(&:package).uniq
  end

end
