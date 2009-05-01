class <%= migration_class_name -%> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name -%>, :force => true do |t|
      t.integer :<%= foreign_key -%>, :null => false
      t.string :tg, :length => 3, :null => false # trigrams
      t.integer :score, :default => 1, :null => false
    end
    add_index :<%= table_name -%>, :tg
    add_index :<%= table_name -%>, :<%= foreign_key %>
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
