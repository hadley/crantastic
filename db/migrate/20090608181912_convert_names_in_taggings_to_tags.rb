class ConvertNamesInTaggingsToTags < ActiveRecord::Migration
  def self.up
    Tagging.all.each do |tagging|
      # Must use array index to avoid the "belongs_to :tag"-relation
      next if tagging["tag"].blank?
      tagging.tag = Tag.find_or_create_with_like_by_name(tagging["tag"])
      tagging.save!
    end
  end

  def self.down
  end
end
