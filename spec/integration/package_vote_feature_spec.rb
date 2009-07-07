require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Package voting" do

  include WebratHelpers
  include AuthHelper

  setup do
    Version.make
    UserMailer.should_receive(:deliver_signup_notification)
    UserMailer.should_receive(:deliver_activation)
    User.make(:login => "john").activate
  end

  before(:each) do
    @user = User.first
    @user.package_votes.destroy_all
    @pkg = Package.first
    visit login_url
    login_with_valid_credentials
    visit package_url(@pkg)
  end

  it "should be possible to vote for a package" do
    click_button "Vote!"
    response.should have_tag("span", "1 vote")
    response.should have_tag("div.flash", "Thanks for your vote!")
    response.request.path.should == package_path(@pkg)
  end

end
