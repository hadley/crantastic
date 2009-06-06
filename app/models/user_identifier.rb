# == Schema Information
# Schema version: 20090605223154
#
# Table name: user_identifier
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  identifier :string(255)     not null
#

class UserIdentifier < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :identifier
end
