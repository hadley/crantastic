require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WeeklyDigest do

  setup do
    wd = WeeklyDigest.create
    wd.update_attribute(:created_at, DateTime.parse("30 jul 2009"))
  end

  before(:each) do
    @digest = WeeklyDigest.first
  end

  it "should have a start date" do
    @digest.start_date.should == Date.parse("27 jul 2009") # Start of the week 31
  end

  it "should have an end date" do
    @digest.end_date.should == Date.parse("2 aug 2009") # End of the week 31
  end

  it "should have a title" do
    @digest.title.should == "Weekly digest for week #31"
  end

end
