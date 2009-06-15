require File.dirname(__FILE__) + '/../spec_helper'

describe PackagesController do

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

  describe "XHTML Markup" do

    it "should be valid for the index page" do
      get :index
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should be valid for the show page" do
      get :show, :id => 1
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should be valid for the all page" do
      get :all
      response.body.strip_entities.should be_xhtml_strict
    end

  end

end
