# == Schema Information
# Schema version: 20090729182846
#
# Table name: review_comment
#
#  id         :integer         not null, primary key
#  review_id  :integer         not null
#  user_id    :integer         not null
#  title      :string(45)      not null
#  comment    :text            not null
#  created_at :datetime
#  updated_at :datetime
#

class ReviewComment < ActiveRecord::Base

  belongs_to :user
  belongs_to :review

  validates_existence_of :user_id
  validates_existence_of :review_id

  validates_length_of :title, :in => 3..45
  validates_length_of :comment, :minimum => 3

end
