class TagsController < ApplicationController
  # GET /tag
  # GET /tag.xml
  def index
    @tags = Tagging.tags

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tag/1
  # GET /tag/1.xml
  def show
    @tag = Tagging.find_by_tag(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
    end
  end
end
