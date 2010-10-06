class TimelineEventsController < ApplicationController

  before_filter :set_atom

  def index
    @page = (params[:page] || 1).to_i
    @page = 1 if @page == 0

    respond_to do |format|
      format.html { @timeline_events = TimelineEvent.paginate_filtered_events(@page) }
      format.atom { @timeline_events = TimelineEvent.recent }
      format.js do
        @timeline_events = TimelineEvent.paginate_filtered_events(@page)
        render :partial => "paginated_events",
               :locals => { :timeline_events => @timeline_events }
      end
    end
  end

  def show
    @timeline_event = TimelineEvent.find(params[:id])
    respond_to do |format|
      format.html { }
    end
  rescue ActiveRecord::RecordNotFound
    rescue_404
  end

  private

  def set_atom
    @atom = {
      :url => "http://feeds.feedburner.com/LatestActivityOnCrantastic",
      :title => "Latest activity on crantastic"
    }
  end

end
