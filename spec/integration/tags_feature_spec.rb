require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Tags" do

  include WebratHelpers

  setup do
    Factory.create(:version)
    UserMailer.should_receive(:deliver_signup_notification)
    UserMailer.should_receive(:deliver_activation)
    Factory.create(:user, :login => 'john').activate
  end

  before(:each) do

  end

  it "should add tags to a package" do
    visit package_url(Package.first)
    click_link "Add tags"

    response.request.path.should == login_path
    login_with_valid_credentials
    response.request.path.should == new_package_tagging_path(Package.first)

    fill_in "tag_name", :with => "test tag"
    click_button "Tag it!"

    response.request.path.should == package_path(Package.first)
    response.should have_tag("li", "test tag")
    response.should have_tag("li", "Add tags")
  end

end
