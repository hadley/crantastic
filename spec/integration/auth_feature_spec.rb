require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Login" do

  include WebratHelpers

  setup do
    Version.make
    UserMailer.should_receive(:deliver_signup_notification)
    UserMailer.should_receive(:deliver_activation)
    User.make(:login => "john").activate
  end

  before(:each) do
    visit login_url
  end

  it "should login an user with valid credentials" do
    login_with_valid_credentials

    assert_contain "Logged in successfully"
    response.should have_tag("h1", "john")
    response.should have_tag("a", "Edit your details")
  end

  it "should not login an user with invalid credentials" do
    fill_in "login", :with => "john"
    fill_in "password", :with => "invalid"
    click_button "login"

    assert_contain "Invalid user name or password. Maybe you meant to sign up instead?"
  end

  it "should redirect to the intended page after login" do
    visit package_path(Package.first)
    click_link "Write one now"
    response.request.path.should == login_path
    login_with_valid_credentials
    response.request.path.should ==
      new_package_review_path(Package.first)
  end

  it "should redirect to root url after logging out" do
    login_with_valid_credentials

    response.request.path.should == user_path(User.first)
    click_link "Log out"

    assert_contain "You have been logged out."
    response.request.path.should == root_path
  end

end
