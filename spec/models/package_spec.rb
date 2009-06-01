require File.dirname(__FILE__) + '/../spec_helper'

describe Package do
  should_have_scope :recent

  should_validate_presence_of :name
  should_validate_length_of :name, :minimum => 2, :maximum => 255

  should_have_many :versions
  should_have_many :package_ratings
  should_have_many :reviews
  should_have_many :taggings

  it "should have unique package names" do
    p = Package.new(:name => "abind")
    p.should be_valid
    p.save!
    Package.new(:name => "abind").should_not be_valid
  end

  it "should use dashes instead of dots for params" do
    p = Package.new(:name => "bio.infer")
    p.to_param.should == "bio-infer"
  end

  it "should calculate its average rating" do
    UserMailer.should_receive(:deliver_signup_notification).twice
    u1 = Factory.create(:user, :login => 'Sally')
    u2 = Factory.create(:user, :login => 'Jolly')

    p = Package.create!(:name => "aaMI")
    p.average_rating.should == 0
    u1.rate!(p, 1)
    p.average_rating.should == 1
    u2.rate!(p, 5)
    p.average_rating.should == 3
  end

  it "should discard old ratings" do
    UserMailer.should_receive(:deliver_signup_notification)
    u = Factory.create(:user)

    p = Package.create!(:name => "abind")

    u.rate!(p, 1)
    u.rating_for(p).rating.should == 1

    u.rate!(p.id, 2) # supports numerical ids as well
    u.rating_for(p).rating.should == 2
  end

  it "should have name as to_s representation" do
    Package.new(:name => "bio.infer").to_s.should == "bio.infer"
  end
end
