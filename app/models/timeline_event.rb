# == Schema Information
# Schema version: 20090618134932
#
# Table name: timeline_event
#
#  id                     :integer         not null, primary key
#  event_type             :string(255)
#  subject_type           :string(255)
#  actor_type             :string(255)
#  secondary_subject_type :string(255)
#  subject_id             :integer
#  actor_id               :integer
#  secondary_subject_id   :integer
#  created_at             :datetime
#  updated_at             :datetime
#

# It's important that the secondary_subject always is set to Package,
# and actor always set to User.
class TimelineEvent < ActiveRecord::Base
  default_scope :order => "timeline_event.created_at DESC"
  named_scope :recent, :limit => 25, :include => [:actor, :subject, :secondary_subject]
  named_scope :recent_for_user, lambda { |u| {
      :limit => 10, :conditions => { :actor_id => u.id },
      :include => [:actor, :subject, :secondary_subject] }
  }
  # Takes a list of package ids as argument.
  named_scope :recent_for_package_ids, lambda { |package_ids| {
      :limit => 25,
      :conditions => ["secondary_subject_id IN (?)", package_ids],
      :include => [:actor, :subject, :secondary_subject] }
  }

  after_create :cache_values

  validates_presence_of :event_type

  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true

  private
  # Values must be cached for items that can change.
  def cache_values
    if self.event_type == "new_package_rating"
      update_attribute(:cached_rating, self.subject.rating)
    end
  end
end
