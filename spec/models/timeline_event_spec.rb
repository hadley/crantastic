require File.dirname(__FILE__) + '/../spec_helper'

describe TimelineEvent do

  should_validate_presence_of :event_type

  setup do
    UserMailer.should_receive(:deliver_signup_notification)
    PackageRating.make
  end

  it "should cache package ratings" do
    event = TimelineEvent.create!(:event_type => "new_package_rating",
                                  :subject => PackageRating.first)
    event.cached_rating.should == PackageRating.first.rating
  end

  it "should know if it is a package event" do
    TimelineEvent.new(:event_type => "new_package").should be_package_event
    TimelineEvent.new(:event_type => "new_version").should be_package_event
    TimelineEvent.new(:event_type => "new_review").should_not be_package_event
  end

end
