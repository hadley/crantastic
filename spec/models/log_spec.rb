require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Log do
  before(:each) do
    @valid_attributes = {
      :message => "test"
    }
  end

  it "should create a new instance given valid attributes" do
    Log.create!(@valid_attributes)
  end
end
