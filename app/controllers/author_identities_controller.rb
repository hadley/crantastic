class AuthorIdentitiesController < ApplicationController

  before_filter :login_required, :find_author

  def new
    @title = "Add new author identity"
  end

  # TODO: Add some additional protection, e.g. captcha
  def create
    if params[:confirm] == "1"
      self.current_user.author_identities << AuthorIdentity.new(:author => @author)
      flash[:notice] = "You are now identified as being #{@author}!"
      redirect_to author_url(@author)
    else
      flash[:notice] = "Please confirm."
      render :new
    end
  end

  private

  def find_author
    @author = Author.find(params[:author_id])
  rescue ActiveRecord::RecordNotFound
    rescue_404
  end

end
