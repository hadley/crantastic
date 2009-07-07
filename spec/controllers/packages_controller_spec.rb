require File.dirname(__FILE__) + '/../spec_helper'

include AuthHelper

describe PackagesController do

  setup do
    Version.make
    Version.make
  end

  integrate_views

  it "should render the index successfully" do
    get :index
    response.should render_template(:index)
  end

  it "should do a 301 for numerical package ids" do
    Package.should_receive(:find).with("1")
    get :show, :id => 1
    response.should be_redirect
    response.status.should == "301 Moved Permanently"
  end

  it "should do a 404 for unknown packages" do
    get :show, :id => "blabla"
    response.status.should == "404 Not Found"
    response.should_not be_redirect
  end

  it "should redirect if not logged in" do
    post :toggle_vote, :id => "aaMI"
    response.should be_redirect
  end

  it "should be possible to toggle package votes" do
    login_as_user(:id => 1, :login => "test")

    pkg_mock = mock_model(Package)
    controller.instance_eval do
      current_user.should_receive(:toggle_vote).with(pkg_mock).and_return(true)
    end
    Package.should_receive(:find_by_param).with("aaMI").and_return(pkg_mock)

    post :toggle_vote, :id => "aaMI"

    response.flash[:notice].should == "Thanks for your vote!"
    response.should be_redirect
  end

  describe "Routes" do

    it "should have routes for votes" do
      params_from(:post, "/packages/ggplot2/toggle_vote").should ==
        { :controller => "packages", :id => "ggplot2", :action => "toggle_vote" }
    end

    it "should have route helper for package vote toggle" do
      toggle_vote_package_path(Package.new(:name => "aaMI")).should ==
        "/packages/aaMI/toggle_vote"
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
