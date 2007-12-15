class Package < ActiveRecord::Base
  has_many :versions
end
