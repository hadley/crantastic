class CreateAuthorIdentities < ActiveRecord::Migration
  def self.up
    create_table :author_identity do |t|
      t.integer :user_id, :null => false
      t.integer :author_id, :null => false

      t.timestamps
    end

    add_index :author_identity, :user_id
    add_index :author_identity, :author_id, :unique => true
    # (Two users can't be the same author, therefore the unique constraint)
  end

  def self.down
    drop_table :author_identity
  end
end
