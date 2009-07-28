require File.dirname(__FILE__) + '/../spec_helper'

describe VersionObserver do

  before(:each) do
    Version.delete_observers
    @obs = VersionObserver.instance
  end

  it "should create new timeline events" do
    pkg = Version.make.package
    v = Version.make(:package => pkg, :version => "2.0")
    TimelineEvent.should_receive(:create!)
    @obs.after_create(v)
  end

  it "should not create timeline events when there already is an event for the package release" do
    v = Version.make
    TimelineEvent.should_not_receive(:create!)
    @obs.after_create(v)
  end

end
