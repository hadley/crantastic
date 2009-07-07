# Parts of this code has been derived from the vote_fu plugin
class PackageVote < ActiveRecord::Base

  named_scope :for_user,     lambda { |u| {:conditions => ["user_id = ?", u.id]} }
  named_scope :recent,       lambda { |*args| {:conditions => ["created_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending,   :order => "created_at DESC"

  belongs_to :package, :counter_cache => true
  belongs_to :user

  attr_accessible :user, :package

  # Limit users to a single vote
  validates_uniqueness_of :package_id, :scope => [:user_id]

  validates_existence_of :package_id
  validates_existence_of :user_id

end
