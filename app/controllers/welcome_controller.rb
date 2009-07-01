class WelcomeController < ApplicationController

  def index
    @atom = {
      :url => timeline_events_url(:format => :atom),
      :title => "Latest activity on crantastic"
    }
    @events = TimelineEvent.recent
  end

end
