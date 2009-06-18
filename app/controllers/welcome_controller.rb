class WelcomeController < ApplicationController

  def index
    @timeline_events = TimelineEvent.recent
  end

end
