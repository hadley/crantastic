class DropPackageTrigramTable < ActiveRecord::Migration
  def self.up
    drop_table :package_trigram
  end

  def self.down
    create_table :package_trigram, :force => true do |t|
      t.integer :package_id, :null => false
      t.string :tg, :length => 3, :null => false # trigrams
      t.integer :score, :default => 1, :null => false
    end
    add_index :package_trigram, :tg
    add_index :package_trigram, :package_id
  end
end
