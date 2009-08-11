class PackagesController < ApplicationController

  before_filter :login_required, :only => [ :toggle_usage  ]

  def index
    page_no = params[:page] || 1
    @search_term = String(params[:search]) || ''

    # Handle nonce values, this is required for clients without JS
    if @search_term.length == 60 && @search_term[-2,2] == '=='
      @search_term = params[@search_term.sub(/==$/, '').to_sym].sub(/^==/, '')
      params[:search] = @search_term
    end

    @packages = Package.paginating_search(@search_term, page_no)
    @title = "#{Package.count} R packages"

    respond_to do |format|
      format.html {}
      format.js do
        render :partial => "packages/list"
      end
    end
  end

  def feed
    @packages = Package.recent
    respond_to do |format|
      format.atom
    end
  end

  def all
    respond_to do |format|
      format.html do
        @packages = Package.all
        @title = "#{Package.count} R packages"
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
      format.html { set_atom_link(self, @package) }
      format.xml  { render :xml => @package }
      format.atom { @events = TimelineEvent.recent_for_package_ids(@package.id) }
    end
  rescue ActiveRecord::RecordNotFound
    rescue_404
  end

  def toggle_usage
    @package = Package.find_by_param(params[:id])
    usage = self.current_user.toggle_usage(@package)
    flash[:notice] = (usage ? "Thanks!" : "You no longer use this package")
    redirect_to(@package)
  end

end
