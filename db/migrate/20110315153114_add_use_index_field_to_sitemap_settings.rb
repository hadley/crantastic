class AddUseIndexFieldToSitemapSettings < ActiveRecord::Migration
  def self.up
    add_column :sitemap_setting, :use_index, :boolean
  end

  def self.down
    remove_column :sitemap_setting, :use_index
  end
end
