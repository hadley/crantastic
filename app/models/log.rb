# == Schema Information
#
# Table name: log
#
#  id         :integer(4)      not null, primary key
#  message    :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

# Simple general purpose model for logging messages
class Log < ActiveRecord::Base

  validates_presence_of :message

  after_create lambda { self.trim_entry_count }

  def self.max_entries; 500; end # Keep a maximum number of log entries in the db

  def self.log!(msg, quiet=false)
    puts msg unless quiet
    Log.create!(:message => msg[0,255])
  end

  def self.log_and_report!(msg, request={}, quiet=false)
    msg = msg.respond_to?(:to_s) ? msg.to_s : "Unknown error"
    self.log!(msg, quiet)
    HoptoadNotifier.notify(
                           :error_class => "Log error",
                           :error_message => msg,
                           :parameters => request
                           )
  end

  def self.trim_entry_count
    Log.find(:first, :order => "id ASC").destroy while Log.count > self.max_entries
    true
  end

  def to_s
    "#{self.created_at.strftime("%d %h, %H:%M:%S")}: #{self.message}"
  end

end
