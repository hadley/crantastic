require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Authentication" do

  include WebratHelpers

  it "should sign up users with valid credentials" do
    visit signup_url
    UserMailer.should_receive(:deliver_activation_instructions)

    fill_in "User name", :with => "john"
    fill_in "Email", :with => "test@test.com"
    fill_in "Password", :with => "test"
    fill_in "Confirm password", :with => "test"
    click_button "Sign up"
    assert_contain "Thanks for signing up.  You'll be getting a confirmation email shortly that will allow you to activate your account."
    response.request.path.should == thanks_path
  end

  it "should not login the user before activation" do
    User.make(:login => "john")
    login_with_valid_credentials

    assert_contain "Invalid user name or password."
  end

  it "should be possible for the user to activate his account" do
    UserMailer.should_receive(:deliver_activation_confirmation)
    visit activate_url(User.make.perishable_token)

    assert_contain "Signup complete! You're now logged in and can start reviewing and tagging."
  end

  it "should not login an user with invalid credentials" do
    visit login_url

    fill_in "login", :with => "john"
    fill_in "password", :with => "invalid"
    click_button "login"

    assert_contain "Invalid user name or password. Maybe you meant to sign up instead?"
  end

  describe "activated user" do

    setup do
      User.make(:login => "john").activate
      Version.make
    end

    it "should login an activated user with valid credentials" do
      login_with_valid_credentials

      assert_contain "Logged in successfully"
      response.should have_tag("h1", "john")
      response.should have_tag("a", "Edit your details")
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

end
