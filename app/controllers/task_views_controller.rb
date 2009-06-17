class TaskViewsController < ApplicationController

  def index
    @tags = Tag.task_views
    render :template => "tags/index"
  end

  def show
    @tag = Tag.find_by_param(params[:id], true)
    render :template => "tags/show"
  rescue
    rescue_404
  end

end
