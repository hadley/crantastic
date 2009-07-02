# == Schema Information
# Schema version: 20090702113720
#
# Table name: tag
#
#  id          :integer         not null, primary key
#  name        :string(255)     not null
#  full_name   :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  type        :string(255)
#  version     :string(10)
#

class Priority < Tag
  def self.find_by_param(id)
    self.find_by_name!(id)
  end
end
