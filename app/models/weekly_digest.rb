# == Schema Information
# Schema version: 20090803134959
#
# Table name: weekly_digest
#
#  id         :integer         not null, primary key
#  param      :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

# Uses the created_at attribute to determine the week in question.
# Note that the digests are quite expensive to display since there is
# a /lot/ of SQL queries that gets executed.
#
# A solution could be to store the HTML output from the view in a text-field in
# the DB.
#
# Should probably consider adding an index for the =created_at= column.
class WeeklyDigest < ActiveRecord::Base

  validates_presence_of :param
  validates_uniqueness_of :param

  validates_format_of :param, :with => /^2\d{3}-[0-5]\d$/

  before_validation lambda { |r| r.param = [Time.now.year, Date.today.cweek].join("-") }

  default_scope :order => "id DESC" # Newest digests first

  # Just to keep the API consistent
  def self.find_by_param(param)
    self.find_by_param!(param)
  end

  def title
    "Weekly digest for week #" + week_num.to_s
  end

  def to_s
    title
  end

  def to_param
    param
  end

  def packages
    timeline_events(:event_type => "new_package").map(&:secondary_subject).sort
  end

  def versions
    timeline_events(:event_type => "new_version").map(&:subject).sort
  end

  def reviews
    timeline_events(:event_type => "new_review").map(&:subject)
  end

  # Returns all the timeline events for this week
  # Note that this currently is very inefficient since there is additional
  # queries for each package/version
  def timeline_events(conditions = {})
    TimelineEvent.all(:conditions => {
                        :created_at => start_date..end_date,
                      }.update(conditions))
  end

  # Returns the first date of the week for this digest
  def start_date
    (created_at - (created_at.wday - 1).days).to_date
  end

  # Returns the last date of the week for this digest
  def end_date
    (created_at + (7 - created_at.wday).days).to_date
  end

  def week_num
    created_at.to_date.cweek
  end

end
