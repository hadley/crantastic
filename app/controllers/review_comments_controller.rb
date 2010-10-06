class ReviewCommentsController < ApplicationController

  load_and_authorize_resource

  def new
    @review = Review.find(params[:review_id])
    @review_comment = ReviewComment.new
  end

  def show
    @review_comment = ReviewComment.find(params[:id])
    respond_to do |format|
      format.html { }
    end
  end

  def create
    @review = Review.find(params[:review_id])
    @review_comment = ReviewComment.new(params[:review_comment])
    @review_comment.user = current_user
    @review_comment.review = @review

    if @review_comment.save
      flash[:notice] = "Your review comment has been saved. Thank you!"
      redirect_to package_review_url(@review.package, @review)
    else
      flash[:notice] = "The form did not pass validation."
      render :action => :new
    end
  end

end
