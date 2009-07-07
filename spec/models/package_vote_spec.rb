require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PackageVote do

  setup do
    Package.make
    UserMailer.should_receive(:deliver_signup_notification)
    User.make
  end

  it "should have a counter cache for the number of votes" do
    p = Package.first
    p.package_votes_count.should == 0
    p.package_votes << PackageVote.new(:user => User.first)
    p.reload
    p.package_votes_count.should == 1
  end

end
