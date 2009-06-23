require File.dirname(__FILE__) + '/../spec_helper'

describe Package do

  setup do
    Package.make(:name => "bio.infer", :updated_at => 1.day.ago)
    Package.make(:name => "ggplot2", :updated_at => 2.days.ago)
  end

  should_have_scope :recent

  should_validate_presence_of :name
  should_validate_uniqueness_of :name
  should_validate_length_of :name, :minimum => 2, :maximum => 255

  should_have_many :versions
  should_have_many :package_ratings
  should_have_many :reviews
  should_have_many :taggings

  it "should use dashes instead of dots for params" do
    p = Package.new(:name => "bio.infer")
    p.to_param.should == "bio-infer"
  end

  it "should calculate its average rating" do
    UserMailer.should_receive(:deliver_signup_notification).twice
    u1 = User.make
    u2 = User.make(:login => "somethingelse")

    p = Package.create!(:name => "aaMI")
    p.average_rating.should == 0
    u1.rate!(p, 1)
    p.average_rating.should == 1
    u2.rate!(p, 5)
    p.average_rating.should == 3
  end

  it "should discard old ratings" do
    UserMailer.should_receive(:deliver_signup_notification)
    u = User.make
    p = Package.make

    u.rate!(p, 1)
    r1 = u.rating_for(p)
    r1.rating.should == 1

    u.rate!(p.id, 2) # supports numerical ids as well
    r2 = u.rating_for(p)
    r2.rating.should == 2

    # Should be same PackageRating row
    r1.id.should == r2.id
  end

  it "should have name as to_s representation" do
    Package.new(:name => "bio.infer").to_s.should == "bio.infer"
  end

  it "should be marked as updated after it receives a new version" do
    pkg = Package.find_by_param("bio.infer")
    prev_time = pkg.updated_at
    Version.make(:package => pkg)
    (pkg.updated_at > prev_time).should be_true
  end

  it "should be marked as updated after it receives a new tagging" do
    UserMailer.should_receive(:deliver_signup_notification)
    pkg = Package.find_by_param("ggplot2")
    prev_time = pkg.updated_at
    Tagging.make(:package => pkg)
    (pkg.updated_at > prev_time).should be_true
  end

  it "should be marked as updated after it receives a new rating" do
    UserMailer.should_receive(:deliver_signup_notification)
    pkg = Package.find_by_param("ggplot2")
    prev_time = pkg.updated_at
    PackageRating.make(:package => pkg)
    (pkg.updated_at > prev_time).should be_true
  end

  it "should be marked as updated after it receives a new review" do
    UserMailer.should_receive(:deliver_signup_notification)
    pkg = Package.find_by_param("ggplot2")
    prev_time = pkg.updated_at
    Review.make(:package => pkg)
    (pkg.updated_at > prev_time).should be_true
  end

end
