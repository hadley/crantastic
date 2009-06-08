class ConvertNamesInTaggingsToTags < ActiveRecord::Migration
  def self.up
    Tagging.all.each do |tagging|
      # Must use array index to avoid the "belongs_to :tag"-relation
      if tagging["tag"].strip.blank?
        tagging.destroy
        next
      end
      tagging.tag = Tag.find_or_create_with_like_by_name(tagging["tag"])
      if tagging.valid?
        tagging.save!
      else
        tagging.destroy # Remove invalid taggings
      end
    end
  end

  def self.down
  end
end
