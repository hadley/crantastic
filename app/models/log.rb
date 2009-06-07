# == Schema Information
# Schema version: 20090607204608
#
# Table name: log
#
#  id         :integer         not null, primary key
#  message    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Simple general purpose model for logging messages
class Log < ActiveRecord::Base
  validates_presence_of :message

  def self.log!(msg, quiet=false)
    puts msg unless quiet
    Log.create!(:message => msg)
  end
end
