class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :package

  def description
    [title, review].join(". ")
  end
  
end
