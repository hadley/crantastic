class CreateUserIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :user_identifier do |t|
      t.belongs_to :user, :null => false
      t.string :identifier, :null => false
    end

    add_index :user_identifier, :identifier, :unique => true
  end

  def self.down
    drop_table :user_identifier
  end
end
