class PackagesController < ApplicationController

  def index
    page_no = params[:page] || 1
    @search_term = String(params[:search])

    respond_to do |format|
      format.html do
        @packages = Package.search(@search_term, params[:page])
      end
      format.js do
        @packages = Package.search(@search_term, params[:page])
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
    if (id.to_i != 0)
      pkg = Package.find(id)
      response.headers["Status"] = "301 Moved Permanently"
      redirect_to url_for(pkg)
      return
    end

    @package = Package.find_by_name(id.gsub("-", "."))
    @version = @package.latest

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package }
    end
  end

end
