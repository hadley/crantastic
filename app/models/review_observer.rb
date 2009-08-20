class ReviewObserver < ActiveRecord::Observer

  # Store the version that was reviewed. Should be the latest version of the
  # package.
  def before_create(review)
    review.version = review.package.latest
  end

end
