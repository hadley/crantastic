class CreateTrigramsTableForPackage < ActiveRecord::Migration
  def self.up
    create_table :package_trigram, :force => true do |t|
      t.integer :package_id, :null => false
      t.string :tg, :length => 3, :null => false # trigrams
      t.integer :score, :default => 1, :null => false
    end
    add_index :package_trigram, :tg
    add_index :package_trigram, :package_id
  end

  def self.down
    drop_table :package_trigram
  end
end
