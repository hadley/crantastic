class Tagging < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
  
  def self.tags
  end
  
end
