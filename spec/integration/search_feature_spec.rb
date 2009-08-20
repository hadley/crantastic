require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Search" do

  before(:each) do
  end

  it "should show search results" do
    visit root_url
    fill_in "q", :with => "test"

    Package.should_receive(:find_by_solr).and_return(nil)
    click_button "Search"

    response.should have_tag("h1", "Search")
    assert_contain "Sorry, no results were found. Please try another search query."
  end

end
