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

  def description
    [title, review].join(". ")
  end
  
end
