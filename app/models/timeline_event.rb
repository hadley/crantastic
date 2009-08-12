# == Schema Information
# Schema version: 20090702113720
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
#  cached_value           :string(255)
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

  ###
  # @param [Tag, String] tag
  # @return [Array]
  def self.recent_for_tag(tag)
    package_ids = Tagging.all(:include => :tag,
                              :conditions => ["tag.name = ?",
                                              tag.to_s]).map(&:package_id)
    self.recent_for_package_ids(package_ids)
  end

  def self.recent_for_author(author)
    package_ids =
      Version.find_by_sql("SELECT DISTINCT(package_id) FROM version " +
                          "WHERE (version.maintainer_id = #{author.id})").map(&:package_id)
    self.recent_for_package_ids(package_ids)
  end

  ## No. of events to show per page.
  def self.per_page; 25; end

  def self.paginate_recent(search_results_page=1)
    paginate({ :include => [:actor, :subject, :secondary_subject],
               :page => search_results_page })
  end

  def package_event?
    %w(new_package new_version).include?(self.event_type) ? true : false
  end

  private
  # Values must be cached for items that can change.
  def cache_values
    case self.event_type
    when "new_package_rating" then
      self.update_attribute(:cached_value, self.subject.rating.to_s)
    when "updated_task_view" then
      self.update_attribute(:cached_value, self.subject.version)
    end
  end
end
