require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VersionsController do

  setup do
    Version.make(:package => Package.make(:name => "rJython"))
  end

  integrate_views

  it "should have an atom feed" do
    get :feed, :format => "atom"
    response.should have_tag('title', "New package versions on crantastic")
    response.should be_success
  end

end
