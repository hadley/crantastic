class TaggingObserver < ActiveRecord::Observer

  def after_create(tagging)
    [tagging.package, tagging.tag, tagging.user].each do |i|
      i.update_attribute(:updated_at, Time.now)
    end
  end

end
