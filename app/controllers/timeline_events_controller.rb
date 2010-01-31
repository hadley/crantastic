class TimelineEventsController < ApplicationController

  resource_controller

  actions :index, :show

  before_filter :set_atom

  show.failure.wants.html { rescue_404 }
  index.wants.atom { @events = TimelineEvent.recent }
  index.wants.js { render :partial => "paginated_events", :locals => { :events => @timeline_events } }

  private
  def collection
    @page = (params[:page] || 1).to_i
    @page = 1 if @page == 0
    TimelineEvent.paginate_filtered_events(@page)
  end

  def set_atom
    @atom = {
      :url => "http://feeds.feedburner.com/LatestActivityOnCrantastic",
      :title => "Latest activity on crantastic"
    }
  end

end
