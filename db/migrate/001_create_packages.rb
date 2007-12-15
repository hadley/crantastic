class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :package do |t|
      t.string :name
      t.text :description
    end
  end

  def self.down
    drop_table :package
  end
end
