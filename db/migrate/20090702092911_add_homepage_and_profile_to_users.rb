class AddHomepageAndProfileToUsers < ActiveRecord::Migration
  def self.up
    add_column :user, :homepage, :string
    add_column :user, :profile, :text
    add_column :user, :profile_markdown, :text
  end

  def self.down
    remove_column :user, :homepage
    remove_column :user, :profile
    remove_column :user, :profile_markdown
  end
end
