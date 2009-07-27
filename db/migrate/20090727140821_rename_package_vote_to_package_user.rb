class RenamePackageVoteToPackageUser < ActiveRecord::Migration
  def self.up
    remove_index :package_vote, [:package_id, :user_id]
    rename_table :package_vote, :package_user
    add_index :package_user, [:package_id, :user_id], :unique => true

    remove_index :package, :package_votes_count
    rename_column :package, :package_votes_count, :package_users_count
    add_index :package, :package_users_count

    TimelineEvent.update_all("event_type = 'new_package_user', subject_type = 'PackageUser'",
                             "event_type = 'new_package_vote'")
  end

  def self.down
    remove_index :package_user, [:package_id, :user_id]
    rename_table :package_user, :package_vote
    add_index :package_vote, [:package_id, :user_id], :unique => true

    remove_index :package, :package_users_count
    rename_column :package, :package_users_count, :package_votes_count
    add_index :package, :package_votes_count

    TimelineEvent.update_all("event_type = 'new_package_vote', subject_type = 'PackageVote'",
                             "event_type = 'new_package_user'")
  end
end
