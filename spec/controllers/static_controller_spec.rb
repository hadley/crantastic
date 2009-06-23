require File.dirname(__FILE__) + '/../spec_helper'

describe StaticController do

  integrate_views

  it "should set correct title for the about page" do
    get :about
    assigns[:title].should == "About"
  end

  describe "XHTML Markup" do

    it "should be valid for the about page" do
      get :about
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should be valid for the error 404 page" do
      get :error_404
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should be valid for the error 500 page" do
      get :error_500
      response.body.strip_entities.should be_xhtml_strict
    end

  end

end
