class FilteredEvent

  def initialize(events)
    @events = events
  end

  def events
    @events.group_by { |e| e.event_type }
  end

  def actor
    @events.first.actor
  end

  def count
    @events.size
  end

  def package_event?
    false
  end

  def user_event?
    true
  end

  # Picks the most recent created_at date
  def created_at
    @events.map(&:created_at).max
  end

end
