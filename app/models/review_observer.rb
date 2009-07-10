class ReviewObserver < ActiveRecord::Observer

  def after_create(review)
    [review.package, review.user].each do |i|
      i.update_attribute(:updated_at, Time.now)
    end
  end

  # Store the version that was reviewed. Should be the latest version of the
  # package.
  def before_create(review)
    review.version = review.package.latest
  end

end
