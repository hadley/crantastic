# == Schema Information
#
# Table name: tagging
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  package_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  tag_id     :integer(4)
#

class Tagging < ActiveRecord::Base

  has_one :timeline_event, :foreign_key => :subject_id, :dependent => :destroy

  belongs_to :user, :touch => true
  belongs_to :package, :touch => true
  belongs_to :tag, :touch => true

  fires :new_tagging, :on                => :create,
                      :actor             => :user,
                      :secondary_subject => :package

  validates_existence_of :package_id
  validates_existence_of :user_id
  validates_existence_of :tag_id

  # Users shouldn't be able to tag a package multiple times with the same tag.
  validates_uniqueness_of :tag_id, :scope => [:package_id, :user_id]

  delegate :name, :to => :package, :prefix => true

  # Calculates the total number of packages that has been tagged.
  #
  # @return [Fixnum]
  def self.package_count
    self.count("DISTINCT(package_id)")
  end

end
