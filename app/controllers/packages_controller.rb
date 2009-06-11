class PackagesController < ApplicationController

  def index
    page_no = params[:page] || 1
    @search_term = String(params[:search]) || ''
    @search_result = Package.paginating_search(@search_term, page_no)
    @packages = @search_result.first

    respond_to do |format|
      format.html {}
      format.js do
        render :partial => "packages/list"
      end

      format.atom do
        @packages = Package.recent
      end
    end
  end

  def all
    respond_to do |format|
      format.html do
        @packages = Package.all
      end

      format.atom do
        @packages = Package.recent
        render :template => "packages/index"
      end
    end
  end

  def show
    id = params[:id]
    if id.to_i != 0
      redirect_to url_for(Package.find(id)), :status => 301
      return
    end

    @package = Package.find_by_param(id)
    @version = @package.latest

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package }
    end
  rescue ActiveRecord::RecordNotFound
    rescue_404
  end

end
