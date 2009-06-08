# == Schema Information
#
# Table name: tagging
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  package_id :integer
#  tag        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tagging < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
  belongs_to :tag

  validates_existence_of :package_id
  validates_existence_of :user_id
  validates_existence_of :tag_id

  # Users shouldn't be able to tag a package multiple times with the same tag.
  validates_uniqueness_of :tag_id, :scope => :user_id

  # Calculates the total number of packages that has been tagged.
  #
  # @return [Fixnum]
  def self.package_count
    Tagging.count("DISTINCT(package_id)")
  end
end
