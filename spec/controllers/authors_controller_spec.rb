require File.dirname(__FILE__) + '/../spec_helper'

describe AuthorsController do

  it "should do a 404 for unknown ids" do
    get :show, :id => 9999
    response.status.should == "404 Not Found"
  end

  describe "XHTML Markup" do

    integrate_views

    it "should have an XHTML Strict compilant index page" do
      get :index
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should have an XHTML Strict compilant show page" do
      get :show, :id => 1
      response.body.strip_entities.should be_xhtml_strict
    end

  end

end
