class TaggingObserver < ActiveRecord::Observer

  def after_create(tagging)
    tagging.package.update_attribute(:updated_at, Time.now)
  end

end
