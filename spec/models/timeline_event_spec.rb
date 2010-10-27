# == Schema Information
#
# Table name: timeline_event
#
#  id                     :integer(4)      not null, primary key
#  event_type             :string(255)
#  subject_type           :string(255)
#  actor_type             :string(255)
#  secondary_subject_type :string(255)
#  subject_id             :integer(4)
#  actor_id               :integer(4)
#  secondary_subject_id   :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#  cached_value           :string(255)
#

require File.dirname(__FILE__) + '/../spec_helper'

describe TimelineEvent do

  should_validate_presence_of :event_type

  setup do
    PackageRating.make
  end

  it "should cache package ratings" do
    event = TimelineEvent.create!(:event_type => "new_package_rating",
                                  :subject => PackageRating.first)
    event.cached_value.should == PackageRating.first.rating.to_s
  end

  it "should cache task view versions" do
    event = TaskView.make.update_version("2009-09-09")
    event.cached_value.should == TaskView.first.version
  end

  it "should know if it is a package event" do
    TimelineEvent.new(:event_type => "new_package").should be_package_event
    TimelineEvent.new(:event_type => "new_version").should be_package_event
    TimelineEvent.new(:event_type => "new_review").should_not be_package_event
  end

end
