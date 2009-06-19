# == Schema Information
# Schema version: 20090615123240
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
#  requires      :string(255)
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
#

# TODO: consider removing the 'requires' field
class Version < ActiveRecord::Base
  has_many :reviews

  belongs_to :package
  belongs_to :maintainer, :class_name => "Author"

  after_create :set_latest_version_for_package

  fires :new_version, :on                => :create,
                      :secondary_subject => :package

  validates_existence_of :package_id
  validates_presence_of :version
  validates_length_of :name, :in => 2..255
  validates_length_of :version, :in => 1..25
  validates_length_of :title, :in => 0..255, :allow_nil => true
  validates_length_of :url, :in => 0..255, :allow_nil => true

  def to_s
    version
  end

  def urls
    (url.split(",") rescue []) + [cran_url]
  end

  def cran_url
    "http://cran.r-project.org/web/packages/#{name}"
  end

  def vname
    name + "_" + version
  end

  def depends
    parse_requirements(attributes["depends"])
  end

  def suggests
    parse_requirements(attributes["suggests"])
  end

  def parse_requirements(reqs)
    reqs.split(",").map{|full| full.split(" ")[0]}.map do |name|
      Package.find_by_name name
    end.compact.sort_by{|v| v.name.downcase } rescue []
  end

  # This runs from lib/tasks/cache.rake. Not sure if this is still needed.
  def cache_maintainer!
    author = Author.new_from_string(attributes["maintainer"])

    self.maintainer = author
    save
  end

  private
  def set_latest_version_for_package
    self.package.update_attribute(:latest_version_id, self.id)
  end

end
