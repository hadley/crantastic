# == Schema Information
# Schema version: 20090627171258
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
#  version     :string(25)
#

class TaskView < Tag
  default_scope :order => "LOWER(name) ASC"

  def self.find_by_param(id)
    self.find_by_name!(id)
  end
end
