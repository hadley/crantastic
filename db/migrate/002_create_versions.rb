class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :version do |t|
      t.integer :package_id
      t.string :name, :title, :license, :version
      t.string :requires, :depends, :suggests
      t.string :maintainer, :author
      t.string :url
      t.date :date

      t.text :readme, :changelog, :news, :diff
      t.timestamps
    end
  end

  def self.down
    drop_table :version
  end
end
