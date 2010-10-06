require File.dirname(__FILE__) + '/../spec_helper'

describe TaggingsController do

  setup do
    Tagging.make
    User.make(:login => "malicious")
  end

  it "should redirect to login when attempting to tag without logging in first" do
    get :new, :package_id => "aaMI"
    response.should be_redirect
    response.flash[:notice].should =~ /You need to log in to access this page/
  end

  it "should allow users to delete their own taggings" do
    tagging = Tagging.first
    #tagging.user.should_receive(:may_destroy!).with(tagging).and_return(true)
    controller.instance_variable_set(:@current_user, tagging.user)
    delete :destroy, :package_id => tagging.package.name, :id => tagging.id
    Tagging.count(:conditions => { :id => tagging.id }).should == 0
  end

  it "should not allow users to delete others taggings" do
    user = User.find_by_login("malicious")
    tagging = Tagging.first
    #user.should_receive(:may_destroy!).with(tagging).and_raise(CanCan::AccessDenied)
    controller.instance_variable_set(:@current_user, user)
    delete :destroy, :package_id => tagging.package.name, :id => tagging.id
    Tagging.count(:conditions => { :id => tagging.id }).should == 1
    response.status.should == "403 Forbidden"
  end

end
