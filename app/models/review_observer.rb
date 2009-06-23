class ReviewObserver < ActiveRecord::Observer

  def after_create(review)
    review.package.update_attribute(:updated_at, Time.now)
  end

end
