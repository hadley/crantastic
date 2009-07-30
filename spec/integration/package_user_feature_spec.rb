require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Package users" do

  include WebratHelpers
  include AuthHelper

  setup do
    Version.make
    User.make(:login => "john").activate
  end

  before(:each) do
    @user = User.first
    @user.package_users.destroy_all
    @pkg = Package.first
    visit login_url
    login_with_valid_credentials
    visit package_url(@pkg)
  end

  it "should be possible to vote for a package" do
    click_button "I use this!"
    response.should have_tag("span", "1 user")
    response.should have_tag("div.flash")
    response.request.path.should == package_path(@pkg)
  end

end
