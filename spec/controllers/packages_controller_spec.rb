require File.dirname(__FILE__) + '/../spec_helper'

include AuthHelper

describe PackagesController do

  setup do
    Version.make(:package => Package.make(:name => "rJython"))
    Version.make
  end

  integrate_views

  it "should render the index successfully" do
    get :index
    response.should render_template(:index)
  end

  it "should do a 301 for numerical package ids" do
    get :show, :id => Package.find_by_name("rJython").id.to_s
    response.should redirect_to("/packages/rJython")
    response.status.should == "301 Moved Permanently"
  end

  it "should do a 301 if package name differs in case from id" do
    get :show, :id => "rjython"
    response.should redirect_to("/packages/rJython")
    response.status.should == "301 Moved Permanently"
  end

  it "should do a 404 for unknown packages" do
    get :show, :id => "blabla"
    response.status.should == "404 Not Found"
    response.should_not be_redirect
  end

  it "should redirect if not logged in" do
    post :toggle_usage, :id => "aaMI"
    response.should be_redirect
  end

  it "should be possible to toggle package usage" do
    login_as_user(:id => 1, :login => "test")

    pkg_mock = mock_model(Package)
    pkg_mock.should_receive(:update_score!)
    controller.instance_eval do
      current_user.should_receive(:toggle_usage).with(pkg_mock).and_return(true)
    end
    Package.should_receive(:find_by_param).with("aaMI").and_return(pkg_mock)

    post :toggle_usage, :id => "aaMI"

    response.flash[:notice].should == "Thanks!"
    response.should be_redirect
  end

  describe "Routes" do

    it "should have routes for package usage" do
      params_from(:post, "/packages/ggplot2/toggle_usage").should ==
        { :controller => "packages", :id => "ggplot2", :action => "toggle_usage" }
    end

    it "should have route helper for package usage toggle" do
      toggle_usage_package_path(Package.new(:name => "aaMI")).should ==
        "/packages/aaMI/toggle_usage"
    end

  end

  describe "XHTML Markup" do

    it "should be valid for the index page" do
      get :index
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should be valid for the show page" do
      get :show, :id => Package.first.to_param
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should be valid for the all page" do
      get :all
      response.body.strip_entities.should be_xhtml_strict
    end

  end

end
