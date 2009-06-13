require File.dirname(__FILE__) + '/../spec_helper'

include AuthHelper

describe ReviewsController do

  it "should render the index successfully" do
    Review.should_receive(:recent)
    get :index
    response.should render_template(:index)
  end

  it "should redirect to login when attempting to write an review without logging in first" do
    get :new
    response.should be_redirect
    response.flash[:notice].should =~ /You need to log in to access this page/
  end

  it "should let logged in users write new reviews" do
    Package.create!(:name => "TestPkg")
    login_as_user(:id => 1, :login => "test")
    get :new, :package_id => "TestPkg"
    response.should be_success
  end

  it "should require authorization for editing" do
    controller.should_receive(:authorized?)
    get :edit, :id => 1
    response.should be_redirect
  end

  it "should let logged in users edit their own reviews" do
    user = login_as_user(:id => 1, :login => "test")
    Review.should_receive(:find).twice.with("1").and_return(mock_model(Review, :user => user))
    get :edit, :id => 1
    response.should be_success
  end

  it "should not let logged in users edit other peoples reviews" do
    user = login_as_user(:id => 1, :login => "test")
    Review.should_receive(:find).once.with("1").and_return(mock_model(Review, :user => User.new))
    get :edit, :id => 1
    response.should_not be_success
    response.should be_redirect
  end

  it "should do a 404 for unknown ids" do
    get :show, :id => 9999
    response.status.should == "404 Not Found"
  end

  describe "XHTML Markup" do

    integrate_views

    before(:each) do
      UserMailer.should_receive(:deliver_signup_notification)
    end

    it "should have an XHTML Strict compilant index page" do
      Review.should_receive(:recent).and_return([Review.make])
      get :index
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should have an XHTML Strict compilant show page" do
      r = Review.make
      Review.should_receive(:find).and_return(r)
      get :show, :id => 1
      response.body.strip_entities.should be_xhtml_strict
    end

  end

end
