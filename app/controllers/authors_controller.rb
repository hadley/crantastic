class AuthorsController < ApplicationController
  # GET /author
  # GET /author.xml
  def index
    @author = Author.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @author }
    end
  end

  # GET /author/1
  # GET /author/1.xml
  def show
    @author = Author.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @author }
    end
  end

end
