# == Schema Information
# Schema version: 20090727140821
#
# Table name: package_user
#
#  id         :integer         not null, primary key
#  package_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

# Parts of this code has been derived from the vote_fu plugin
class PackageUser < ActiveRecord::Base

  belongs_to :package, :counter_cache => true
  belongs_to :user

  fires :new_package_vote, :on => :create,
                           :actor => :user,
                           :secondary_subject => :package

  named_scope :for_user,     lambda { |u| {:conditions => ["user_id = ?", u.id]} }
  named_scope :recent,       lambda { |*args| {:conditions => ["created_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending,   :order => "created_at DESC"

  attr_accessible :user, :package

  # Limit users to a single vote
  validates_uniqueness_of :package_id, :scope => [:user_id]

  validates_existence_of :package_id
  validates_existence_of :user_id

end
