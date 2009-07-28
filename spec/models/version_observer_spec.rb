require File.dirname(__FILE__) + '/../spec_helper'

describe VersionObserver do

  it "should create new timeline events" do
    pkg = Version.make.package
    v = Version.make(:package => pkg, :version => "2.0")
    TimelineEvent.first.subject.should == v
  end

  it "should not create timeline events when there already is an event for the package release" do
    pkg = Package.make
    pkg_event = TimelineEvent.first
    Version.make(:package => pkg,
                 :version => "5.0",
                 :maintainer => Author.first)
    TimelineEvent.first.should == pkg_event
  end

end
