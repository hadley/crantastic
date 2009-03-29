# == Schema Information
#
# Table name: review
#
#  id         :integer         not null, primary key
#  package_id :integer
#  user_id    :integer
#  rating     :integer
#  review     :text
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :package

  before_validation :strip_title_and_review

  validates_length_of :title, :minimum => 3, :message => "(Brief Summary) is too short(minimum is 3 characters)"
  validates_length_of :review, :minimum => 3

  def description
    [title, review].join(". ")
  end

private
  def strip_title_and_review
    self.title.strip!
    self.review.strip!
  end
  
end
