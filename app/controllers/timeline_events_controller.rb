class TimelineEventsController < ApplicationController

  resource_controller

  actions :index, :show

  before_filter :set_atom

  show.failure.wants.html { rescue_404 }
  index.wants.atom { @events = @timeline_events }

  private
  def collection
    TimelineEvent.recent
  end

  def set_atom
    @atom = {
      :url => "http://feeds.feedburner.com/LatestActivityOnCrantastic",
      :title => "Latest activity on crantastic"
    }
  end

end
