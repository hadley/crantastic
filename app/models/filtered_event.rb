class FilteredEvent

  attr_reader :events

  def initialize(events)
    @events = events
  end

  def actor
    @events.first.actor
  end

  def count
    @events.size
  end

end
