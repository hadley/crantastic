require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/search/show" do
  before(:each) do
  end

  it "should let the user know if there were no search results" do
    assigns[:packages] = []
    render 'search/show'
    response.should have_tag('h1', %r[Search])
    response.should have_tag('p', %r[no results were found])
  end
end
