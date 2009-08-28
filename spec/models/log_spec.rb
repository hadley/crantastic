require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Log do
  it "should trim the entry count" do
    Log.should_receive(:trim_entry_count)
    Log.create!(:message => "tst")
  end
end
