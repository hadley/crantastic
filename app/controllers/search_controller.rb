class SearchController < ApplicationController

  def show
    @title = 'Search'

    @search_term = String(params[:q]).mb_chars.strip
    @search_term.gsub!('()', '') # Not allowed in Solr search queries
    @results = Package.find_by_solr(@search_term, :limit => 50).try(:results) || []

    # Redirect to package if the result set was unambiguous
    if @results.size == 1 && pkg = Package.find_by_name(params[:q])
      redirect_to(package_path(pkg))
    end
  end

end
