class PackagesController < ApplicationController

  before_filter :store_location # Redirect back here after logging in

  def index
    page_no = params[:page] || 1
    @search_term = String(params[:search]) || ''
    @search_result = Package.paginating_search(@search_term, page_no)
    @packages = @search_result.first
    @title = "#{Package.count} R packages"
    @atom = packages_path(:format => :atom)

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
        @title = "#{Package.count} R packages"
        @atom = packages_path(:format => :atom)
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
    @tagging = Tagging.new(:package => @package)
    @title = "The #{@package} package"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package }
    end
  rescue ActiveRecord::RecordNotFound
    rescue_404
  end

end
