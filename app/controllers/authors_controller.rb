class AuthorsController < ApplicationController

  # TODO remove create method after the data import script is rewritten

  before_filter :admin_required, :only => :create

  def index
    conditions = params.dup.delete_if { |k,v| !["name", "email"].include?(k) }
    @authors = Author.all(:conditions => conditions)
    @title = "Package Maintainers"

    respond_to do |format|
      format.html { }
      format.xml { render :xml => @authors }
    end
  end

  def show
    @author = Author.find(params[:id])
    @events = TimelineEvent.recent_for_author(@author)

    set_atom_link(self, @author)
    @plural = false
    @title = @author.name

    respond_to do |format|
      format.html { }
      format.atom { }
      format.xml { render :xml => @author }
    end
  end

  def create
    @author = Author.create!(params[:author])
    respond_to do |format|
      format.xml do
        render :xml => @author
      end
    end
  rescue # TODO use more fine-grained error checking
    respond_to do |format|
      format.xml do
        render :nothing => true, :status => :conflict
      end
    end
  end

end
