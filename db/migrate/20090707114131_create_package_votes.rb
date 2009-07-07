class CreatePackageVotes < ActiveRecord::Migration
  def self.up
    create_table :package_vote do |t|
      t.belongs_to :package
      t.belongs_to :user
      t.timestamps
    end

    add_index :package_vote, [:package_id, :user_id], :unique => true
  end

  def self.down
    drop_table :package_vote
  end
end
