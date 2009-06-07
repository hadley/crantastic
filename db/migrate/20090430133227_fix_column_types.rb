class FixColumnTypes < ActiveRecord::Migration
  def self.up
    change_column :version, :description, :text
    change_column :version, :license, :text
    change_column :version, :depends, :text
    change_column :version, :suggests, :text
    change_column :version, :author, :text
  end

  def self.down
    change_column :version, :description, :string
    change_column :version, :license, :string
    change_column :version, :depends, :string
    change_column :version, :suggests, :string
    change_column :version, :author, :string
  end
end
