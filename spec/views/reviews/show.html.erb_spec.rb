require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/reviews" do

  before(:each) do
    @review = Review.make_unsaved(:cached_rating => 4)
    assigns[:review] = @review
  end

  it "should display a review with rating" do
    render "reviews/show"
    response.should have_tag('h1', /A review of #{@review.package}/)
    response.should have_tag('p.rating', "4")
    response.should have_tag('strong', @review.title)
  end

end
