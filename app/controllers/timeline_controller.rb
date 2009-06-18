class TimelineController < ApplicationController

  def show
    @timeline_events = TimelineEvent.recent
  end

end
