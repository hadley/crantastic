class Tag < ActiveRecord::Base
  default_scope :order => "name ASC"

  has_many :taggings
  has_many :packages, :through => :taggings

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[^ ].*[a-zA-Z0-9]$/
  validates_length_of :name, :in => 2..100

  # LIKE is used for cross-database case-insensitivity
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
  end

  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end

  def to_s
    name
  end

  def to_param
    name
  end

  # NOTE: this could be cached later on
  def count
    Tagging.count(:tag_id, :conditions => "tag_id = #{self.id}")
  end
end
