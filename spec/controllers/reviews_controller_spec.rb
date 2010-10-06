require File.dirname(__FILE__) + '/../spec_helper'

include AuthHelper

describe ReviewsController do

  setup do
    Version.make
    Review.make(:package => Package.first)
  end

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
    login_as_user(:id => 1, :login => "test")
    get :new, :package_id => Package.first.id
    response.should be_success
  end

  it "should require authentication for editing" do
    get :edit, :id => 1
    response.should be_redirect
  end

  it "should let logged in users edit their own reviews" do
    user = login_as_user(:id => 1, :login => "test")
    Review.should_receive(:find).with("1").and_return(mock_model(Review, :user => user,
                                                                         :user_id => user.id))
    get :edit, :id => 1
    response.should be_success
    response.should render_template("edit")
  end

  it "should not let logged in users edit other peoples reviews" do
    user = login_as_user(:id => 1, :login => "test")
    Review.should_receive(:find).once.with("1").and_return(mock_model(Review, :user => User.new,
                                                                              :user_id => nil))
    get :edit, :id => 1
    response.should_not be_success
    response.status.should == "403 Forbidden"
  end

  it "should do a 404 for unknown ids" do
    get :show, :id => 9999
    response.status.should == "404 Not Found"
  end

  it "should set correct title for review pages" do
    review = Review.first
    get :show, :id => review.id
    assigns[:title].should == "#{review.user}'s review of #{review.package}"
  end

  describe "XHTML Markup" do

    integrate_views

    before(:each) do
      @review = Review.first
    end

    it "should have an XHTML Strict compilant index page" do
      get :index
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should have an XHTML Strict compilant show page" do
      get :show, :id => @review.id
      response.body.strip_entities.should be_xhtml_strict
    end

  end

end
