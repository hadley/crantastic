# == Schema Information
# Schema version: 20090402200300
#
# Table name: package_rating
#
#  id         :integer         not null, primary key
#  package_id :integer
#  user_id    :integer
#  rating     :integer
#  created_at :datetime
#  updated_at :datetime
#

class PackageRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :package

  validates_presence_of :package_id, :user_id
  # users can only have one active vote per package:
  validates_uniqueness_of :user_id, :scope => :package_id
  validates_format_of :rating, :with => /^[1-5]$/

  # Calculates the average rating for a given package
  def self.calculate_average(pkg)
    average('rating', :conditions => "package_id = #{pkg.id}").to_i.round
  end
end
