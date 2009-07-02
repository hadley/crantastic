class PrioritiesController < ApplicationController

  def index
    @tags = Priority.all
    render :template => "tags/index"
  end

  def show
    @tag = Priority.find_by_param(params[:id])
    @events = TimelineEvent.recent_for_tag(@tag)
    set_atom_link(self, @tag)

    respond_to do |format|
      format.html { render :template => "tags/show" }
      format.atom { render :template => "tags/show" }
    end

  rescue ActiveRecord::RecordNotFound
    rescue_404
  end

end
