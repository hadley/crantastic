class PackageRatingObserver < ActiveRecord::Observer

  def after_save(package_rating)
    package_rating.package.update_attribute(:updated_at, Time.now)
  end

end
