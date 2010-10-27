# == Schema Information
#
# Table name: log
#
#  id         :integer(4)      not null, primary key
#  message    :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Log do
  it "should trim the entry count" do
    Log.should_receive(:trim_entry_count)
    Log.create!(:message => "tst")
  end
end
