require File.dirname(__FILE__) + '/../spec_helper'

describe WelcomeController do

  setup do
    make_timeline_event_for_version
  end

  integrate_views

  it "should set the page title" do
    get :index
    response.should have_tag('title', "It's crantastic!")
    response.should be_success
  end

  describe "XHTML Markup" do

    it "should be valid for the index page" do
      get :index
      response.body.strip_entities.should be_xhtml_strict
    end

  end

end
