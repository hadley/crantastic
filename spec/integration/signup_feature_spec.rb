require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Login" do

  include WebratHelpers

  before(:each) do
    UserMailer.should_receive(:deliver_signup_notification)
    visit signup_url
  end

  it "should be possible to sign up with credentials" do
    fill_in "User name", :with => Sham.login
    fill_in "Email", :with => Sham.email
    fill_in "Password", :with => "test"
    fill_in "Confirm Password", :with => "test"
    click_button "Sign up"
    response.should have_tag("div.flash", "Successfully created!")
    assert_contain "Thanks for signing up.  You'll be getting a confirmation email shortly that will allow you to activate your account."
    response.request.path.should == thanks_path
  end

end
