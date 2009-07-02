module TagsHelper

  def tag_cloud(tags, classes)
    # Minimum 1, to prevent division by zero
    max_count = [tags.sort_by(&:weight).last.weight, 1].max.to_f

    tags.each do |tag|
      index = ((tag.weight / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end

end
