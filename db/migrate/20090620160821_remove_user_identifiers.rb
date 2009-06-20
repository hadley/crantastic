class RemoveUserIdentifiers < ActiveRecord::Migration
  def self.up
    drop_table :user_identifier
  end

  def self.down
    create_table :user_identifier do |t|
      t.belongs_to :user, :null => false
      t.string :identifier, :null => false
    end
  end
end
