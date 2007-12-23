class ReviewsController < ApplicationController
  # GET /review
  # GET /review.xml
  def index
    @reviews = Review.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /review/1
  # GET /review/1.xml
  def show
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /review/new
  # GET /review/new.xml
  def new
    @review = Review.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review }
    end
  end

  # GET /review/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  # POST /review
  # POST /review.xml
  def create
    @review = Review.new(params[:review])

    respond_to do |format|
      if @review.save
        flash[:notice] = 'Review was successfully created.'
        format.html { redirect_to(@review) }
        format.xml  { render :xml => @review, :status => :created, :location => @review }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /review/1
  # PUT /review/1.xml
  def update
    @review = Review.find(params[:id])

    respond_to do |format|
      if @review.update_attributes(params[:review])
        flash[:notice] = 'Review was successfully updated.'
        format.html { redirect_to(@review) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /review/1
  # DELETE /review/1.xml
  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to(review_url) }
      format.xml  { head :ok }
    end
  end
end
