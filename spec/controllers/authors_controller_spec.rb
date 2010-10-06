require File.dirname(__FILE__) + '/../spec_helper'

describe AuthorsController do

  def setup
    @version = Version.make
    @author = @version.maintainer
  end

  integrate_views

  it "should do a 404 for unknown ids" do
    get :show, :id => 9999
    response.status.should == "404 Not Found"
    response.should render_template("static/error_404")
  end

  it "should have a atom feed for author activity" do
    get :show, :id => @author.id, :format => "atom"
    response.status.should == "200 OK"
  end

  it "should pluralize the title" do
    get :index
    response.should have_tag('title', "Package Maintainers. They're crantastic!")
  end

  it "should set a singular title for the author pages" do
    get :show, :id => @author.id
    response.should have_tag('title', "#{@author.name}. It's crantastic!")
  end

  describe "XHTML Markup" do

    it "should be valid for the index page" do
      get :index
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should be valid for the show page" do
      get :show, :id => @author.id
      response.body.strip_entities.should be_xhtml_strict
    end

  end

end
