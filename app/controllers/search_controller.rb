class SearchController < ApplicationController

  def show
    @title = 'Search'

    @search_term = String(params[:q]).mb_chars.strip
    @search_term.gsub!('()', '') # Not allowed in Solr search queries
    @results = Package.find_by_solr(@search_term, :limit => 50).try(:results) || []

    # Redirect to package if the result set was unambiguous
    if Package.find_by_name(params[:q]) && @results.size == 1
      redirect_to :controller => "packages", :action => "show", :id => params[:q]
    end
  end

end
