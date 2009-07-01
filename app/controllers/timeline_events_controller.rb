class TimelineEventsController < ApplicationController

  resource_controller

  actions :index, :show

  show.failure.wants.html { rescue_404 }
  show.wants.html do
    @atom = {
      :url => timeline_events_url(:format => :atom),
      :title => "Latest activity on crantastic"
    }
  end
  index.wants.atom { @events = @timeline_events }

  private
  def collection
    TimelineEvent.recent
  end

end
