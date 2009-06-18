module TagsHelper

  def tag_cloud(tags, classes)    
    max_count = tags.sort_by(&:weight).last.weight.to_f

    tags.each do |tag|
      index = ((tag.weight / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end

end
