require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PackageRating do
  before(:each) do
    @valid_attributes = {
      :user_id => 2,
      :package_id => 2,
      :rating => 2
    }
  end

  it "should create a new instance given valid attributes" do
    PackageRating.create!(@valid_attributes)
  end

  it "should only accept ratings ranging from 1 to 5" do
    r = PackageRating.new(@valid_attributes)

    1.upto(5) do |i|
      r.rating = i
      r.should be_valid
    end

    [0,6,-1,10].each do |i|
      r.rating = i
      r.should_not be_valid
    end
  end

  it "shouldnt be possible for a user to have two active votes for one package" do
    PackageRating.create(@valid_attributes).should be_valid
    PackageRating.create(@valid_attributes).should_not be_valid
  end
end
