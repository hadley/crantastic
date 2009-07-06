require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Tags" do

  include WebratHelpers

  setup do
    Version.make
    UserMailer.should_receive(:deliver_signup_notification)
    UserMailer.should_receive(:deliver_activation)
    User.make(:login => "john").activate
  end

  before(:each) do

  end

  it "should add tags to a package" do
    visit package_url(Package.first)
    click_link "Add tags"

    response.request.path.should == login_path
    login_with_valid_credentials
    response.request.path.should == new_package_tagging_path(Package.first)

    fill_in "tag_name", :with => "test"
    click_button "Tag it!"

    response.request.path.should == package_path(Package.first)
    response.should have_tag("li", "test")
    response.should have_tag("li", "Add tags")
  end

  it "should add multiple tags to a package" do
    visit package_url(Package.first)
    click_link "Add tags"

    response.request.path.should == login_path
    login_with_valid_credentials
    response.request.path.should == new_package_tagging_path(Package.first)

    fill_in "tag_name", :with => "MachineLearning, NLP"
    click_button "Tag it!"

    response.request.path.should == package_path(Package.first)
    response.should have_tag("li", "MachineLearning")
    response.should have_tag("li", "NLP")
    response.should have_tag("li", "Add tags")
  end

end

