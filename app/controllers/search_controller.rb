class SearchController < ApplicationController

  def show
    @title = 'Search'

    @search_term = String(params[:q]).mb_chars.strip
    @packages = Package.search(@search_term)
    if Package.find_by_name(params[:q]) && @packages.count == 1
      redirect_to :controller => "packages", :action => "show", :id => params[:q]
    end
  end

end
