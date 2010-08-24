class DropAuthorVersionJoinTable < ActiveRecord::Migration
  def self.up
    drop_table :author_version
  end

  def self.down
    create_table :author_version, :id => false do |t|
      t.integer :author_id, :null => false
      t.integer :version_id, :null => false
    end

    add_index :author_version, [:author_id, :version_id], :unique => true

    Version.all.each { |v| v.authors = [v.maintainer].compact; v.save }
  end
end
