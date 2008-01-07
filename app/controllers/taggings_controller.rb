class TaggingsController < ApplicationController
  before_filter :login_required, :only => [ :new, :create  ]
  before_filter :authorization_required, :only => [ :edit, :update  ]

  def authorized?
    tagging = Tagging.find(params[:id])
    tagging.user == current_user
  end

  # GET /tagging
  # GET /tagging.xml
  def index
    @taggings = Tagging.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tagging }
    end
  end

  # GET /tagging/1
  # GET /tagging/1.xml
  def show
    @tagging = Tagging.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tagging }
    end
  end

  # GET /tagging/new
  # GET /tagging/new.xml
  def new
    @tagging = Tagging.new
    @tagging.user = current_user
    @tagging.package = Package.find(params[:package_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tagging }
    end
  end

  # GET /tagging/1/edit
  def edit
    @tagging = Tagging.find(params[:id])
  end

  # POST /tagging
  # POST /tagging.xml
  def create
    @tagging = Tagging.new(params[:tagging])
    @tagging.user = current_user

    respond_to do |format|
      if @tagging.save
        flash[:notice] = 'Tagging was successfully created.'
        format.html { redirect_to(@tagging.package) }
        format.xml  { render :xml => @tagging, :status => :created, :location => @tagging }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tagging.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tagging/1
  # PUT /tagging/1.xml
  def update
    @tagging = Tagging.find(params[:id])

    respond_to do |format|
      if @tagging.update_attributes(params[:tagging])
        flash[:notice] = 'Tagging was successfully updated.'
        format.html { redirect_to(@tagging.package) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tagging.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tagging/1
  # DELETE /tagging/1.xml
  def destroy
    @tagging = Tagging.find(params[:id])
    @tagging.destroy

    respond_to do |format|
      format.html { redirect_to(tagging_url) }
      format.xml  { head :ok }
    end
  end
end
