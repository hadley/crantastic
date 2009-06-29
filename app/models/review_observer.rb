class ReviewObserver < ActiveRecord::Observer

  def after_create(review)
    [review.package, review.user].each do |i|
      i.update_attribute(:updated_at, Time.now)
    end
  end

end
