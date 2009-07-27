require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PackageUser do

  setup do
    Package.make
    UserMailer.should_receive(:deliver_signup_notification)
    User.make
  end

  it "should have a counter cache for the number of votes" do
    p = Package.first
    p.package_users_count.should == 0
    p.package_users << PackageUser.new(:user => User.first)
    p.reload
    p.package_users_count.should == 1
  end

end
