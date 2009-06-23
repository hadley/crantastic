class AddSitemapTable < ActiveRecord::Migration
  def self.up
    create_table "sitemap_setting", :force => true do |t|
      t.string :name
      t.string :description
      t.string :xml_location
      t.string :username
      t.string :password
    
      t.timestamps
    end
    
    create_table "sitemap_static_link", :force => true do |t|
      t.string :url
      t.string :name
      t.float :priority
      t.string :frequency
      t.string :section
      
      t.timestamps
    end
    
    create_table "sitemap_widget", :force => true do |t|
      t.string :widget_model
      t.string :index_named_route
      t.string :frequency_index
      t.string :frequency_show
      t.float :priority
      t.string :custom_finder
      
      t.timestamps
    end
    
  end

  def self.down
    drop_table "sitemap_setting"
    drop_table "sitemap_static_link"
    drop_table "sitemap_widget"
  end
end
