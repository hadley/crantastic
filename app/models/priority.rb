# == Schema Information
#
# Table name: tag
#
#  id          :integer(4)      not null, primary key
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
