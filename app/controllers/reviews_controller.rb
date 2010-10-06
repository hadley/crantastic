class ReviewsController < ApplicationController

  before_filter :require_user, :only => [:new, :edit]

  load_and_authorize_resource

  def index
    @reviews = Review.recent
    @package = parent_object
    @title = (@package.nil?) ? "Recent reviews" : "Reviews for #{@package}"
    @plural = true

    respond_to do |format|
      format.html { }
    end
  end

  def new
    @package = parent_object
  end

  def show
    @review = Review.find(params[:id])
    @title = @review.to_s

    respond_to do |format|
      format.html { }
    end
  end

  def create
    @review = Review.new(params[:review])
    @review.package = parent_object
    @review.user = current_user

    if @review.save
      flash[:notice] = "Your review has been saved. Thank you!"
      redirect_to @review
    else
      flash[:notice] = "The form did not pass validation."
      render :action => :edit
    end
  end

  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(params[:review])
      flash[:notice] = "Your review has been updated!"
      redirect_to @review
    else
      flash[:notice] = "The form did not pass validation."
      render :action => :edit
    end
  end

  private
  def parent_object
    return nil if params[:package_id].blank?
    if params[:package_id].to_i == 0
      Package.find_by_param(params[:package_id])
    else
      Package.find(params[:package_id])
    end
  end

end
