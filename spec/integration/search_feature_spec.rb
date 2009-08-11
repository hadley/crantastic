require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Search" do

  before(:each) do
  end

  it "should show search results" do
    visit root_url
    fill_in "q", :with => "test"
    click_button "Search"

    Package.should_receive(:find_by_solr).and_return([])
    response.should have_tag("h1", "Search")
    assert_contain "Sorry, no results were found. Please try another search query."
  end

end
