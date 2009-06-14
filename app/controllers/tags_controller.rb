class TagsController < ApplicationController

  resource_controller

  actions :index, :show

  index.wants.html { @title = "Tags" }
  show.failure.wants.html { rescue_404 }

  private
  def object
    # Need to use =find_by_param= since we don't use numeric ids for tags.
    Tag.find_by_param(params[:id])
  end

end
