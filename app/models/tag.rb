class Tag < ActiveRecord::Base
  default_scope :order => "name ASC"

  # Taggings should be destroyed together with the tag
  has_many :taggings, :dependent => :destroy
  has_many :packages, :through => :taggings

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[A-Za-z][a-zA-Z\d ]*[A-Za-z\d]$/
  validates_length_of :name, :in => 2..100

  # LIKE is used for cross-database case-insensitivity
  # (borrowed from acts_as_taggable_on)
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
  end

  def self.find_by_param(id)
    self.find_by_name(id.tr("-", " ")) or raise ActiveRecord::RecordNotFound
  end

  def ==(other)
    other.is_a?(Tag) && other.name == self.name
  end

  def to_s
    name
  end

  def to_param
    name.tr(" ", "-")
  end

  # NOTE: this could be cached later on
  def count
    Tagging.count(:tag_id, :conditions => "tag_id = #{self.id}")
  end
end
