class PackageRatingObserver < ActiveRecord::Observer

  def after_save(package_rating)
    ([package_rating.package,
      package_rating.user] + package_rating.package.tags).each do |i|
      i.update_attribute(:updated_at, Time.now)
    end
  end

end
