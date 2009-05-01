class FixColumnTypes < ActiveRecord::Migration
  def self.up
    change_column :version, :description, :text
    change_column :version, :license, :text
    change_column :version, :depends, :text
    change_column :version, :suggests, :text
    change_column :version, :author, :text
  end

  def self.down
  end
end
