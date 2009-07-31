# == Schema Information
# Schema version: 20090731172118
#
# Table name: tagging
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  package_id :integer
#  created_at :datetime
#  updated_at :datetime
#  tag_id     :integer
#  active     :boolean         default(TRUE), not null
#

class Tagging < ActiveRecord::Base

  belongs_to :user
  belongs_to :package
  belongs_to :tag

  named_scope :active, :conditions => { :active => true }

  fires :new_tagging, :on                => :create,
                      :actor             => :user,
                      :secondary_subject => :package

  validates_existence_of :package_id
  validates_existence_of :user_id
  validates_existence_of :tag_id

  # Users shouldn't be able to tag a package multiple times with the same tag.
  validates_uniqueness_of :tag_id, :scope => [:package_id, :user_id]

  # Calculates the total number of packages that has been tagged.
  #
  # @return [Fixnum]
  def self.package_count
    Tagging.count("DISTINCT(package_id)")
  end
end
