class Package < ActiveRecord::Base
  has_many :versions
  
  def latest
    versions[0]
  end
  
end
