# Virtual model for daily summaries. The packages, versions, and reviews methods
# are duplicated here and in WeeklyDigest - if more duplication occurs later,
# we can use a module or maybe even switch to STI.
class DailyDigest

  # Duck-typing to be perceived as ActiveRecord-like
  def self.find_by_param(param)
    date = Date.parse(param.to_s)
    # No data available before 20090623, or from the future.
    raise if date < Date.parse("20090623") or date > Time.zone.now.to_date # UTC
    DailyDigest.new(param, date)
  rescue
    raise ActiveRecord::RecordNotFound
  end

  def initialize(day, date=Date.parse(day.to_s))
    @day = day
    @date = date
  end

  def title
    "Daily digest for #{@day}"
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

  def timeline_events(conditions = {})
    conds = "DATE(created_at) = '#{@date.to_s(:db)}'"
    conds += " AND event_type = '#{conditions[:event_type]}'" if conditions[:event_type]
    TimelineEvent.all(:conditions => conds)
  end

end
