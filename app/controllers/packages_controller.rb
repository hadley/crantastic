class PackagesController < ApplicationController

  before_filter :login_required, :only => :toggle_usage
  before_filter :admin_required, :only => :create

  def index
    page_no = (params[:page] || 1).to_i
    page_no = 1 if page_no == 0
    @search_term = String(params[:search]) || ''

    # Handle nonce values, this is required for clients without JS
    if @search_term.length == 60 && @search_term[-2,2] == '=='
      @search_term = params[params.keys.find { |i| i.length == 58 }].sub(/^==/, '')
      params[:search] = @search_term
    end

    options = {}
    if params[:popcon]
      options = {:order => "score DESC, package_users_count DESC"}
    end

    @packages = Package.paginating_search(@search_term, page_no, options)

    @title = "#{Package.count} R packages"

    respond_to do |format|
      format.html { render :template => "packages/index" }
      format.js { render :partial => "packages/list" }
      format.xml { render :xml => @packages }
    end
  end

  def search
    index
  end

  def feed
    @packages = Package.recent
    respond_to do |format|
      format.atom
    end
  end

  def all
    @packages = Package.all(:include => :latest_version)
    respond_to do |format|
      format.html { @title = "#{Package.count} R packages" }
      format.bibjs {render :text => @packages.to_json}
      format.xml do
        render :xml => @packages.to_xml
      end
    end
  end

  def show
    id = params[:id]
    if id.to_i != 0
      redirect_to url_for(Package.find(id)), :status => 301
      return
    end

    @package = Package.find_by_param(id) # case-insensitive
    # Redirect to correct url if e.g. someone accesses /packages/rjython (should be rJython)
    if @package.name != id
      redirect_to url_for(@package), :status => 301
      return
    end
    @version = @package.latest
    @tagging = Tagging.new(:package => @package)
    @title = "The #{@package} package"

    respond_to do |format|
      format.html  { set_atom_link(self, @package) }
      format.bibjs { render :text => @package.to_json}
      format.xml   { render :xml => @package }
      format.atom  { @events = TimelineEvent.recent_for_package_ids(@package.id) }
    end
  rescue ActiveRecord::RecordNotFound
    rescue_404
  end

  def create
    @package = Package.create!(params[:package])
    respond_to do |format|
      format.xml do
        render :xml => @package
      end
    end
  rescue
    respond_to do |format|
      format.xml do
        render :nothing => true, :status => :conflict
      end
    end
  end

  def toggle_usage
    @package = Package.find_by_param(params[:id])
    usage = self.current_user.toggle_usage(@package)
    @package.update_score!
    flash[:notice] = (usage ? "Thanks!" : "You no longer use this package")
    redirect_to(@package)
  end

end
