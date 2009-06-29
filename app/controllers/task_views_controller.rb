class TaskViewsController < ApplicationController

  def index
    @tags = TaskView.all
    render :template => "tags/index"
  end

  def show
    @tag = TaskView.find_by_param(params[:id])
    @events = TimelineEvent.recent_for_tag(@tag)

    respond_to do |format|
      format.html { render :template => "tags/show" }
      format.atom
    end

  rescue ActiveRecord::RecordNotFound
    rescue_404
  end

end
