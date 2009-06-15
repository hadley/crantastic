require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PackageRating do
  before(:each) do
    UserMailer.should_receive(:deliver_signup_notification)
    @valid_attributes = {
      :user => User.make,
      :package => Package.make,
      :rating => 2
    }
  end

  should_allow_values_for :rating, "1", "2", "3", "4", "5"
  should_not_allow_values_for :rating, "0", "6", "-1", "10", "05"

  it "should create a new instance given valid attributes" do
    PackageRating.create!(@valid_attributes)
  end

  it "shouldnt be possible for a user to have two active votes for one package" do
    PackageRating.create(@valid_attributes).should be_valid
    PackageRating.create(@valid_attributes).should_not be_valid
  end

  it "should be possible for a user to have two active votes for one package with different aspects" do
    PackageRating.create(@valid_attributes).should be_valid
    PackageRating.create(@valid_attributes.merge(:aspect => "documentation")).should be_valid
  end

  it "should have a default rating aspect" do
    PackageRating.create!(@valid_attributes).aspect.should == "overall"
  end
end
