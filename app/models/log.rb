# == Schema Information
# Schema version: 20090613223342
#
# Table name: log
#
#  id         :integer         not null, primary key
#  message    :string(255)     not null
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

  def to_s
    "#{self.created_at.strftime("%d %h, %H:%M:%S")}: #{self.message}"
  end
end
