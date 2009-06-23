class SearchController < ApplicationController
  def show
    @title = 'Search'
    @search_term = String(params[:q]).mb_chars.strip.downcase
    @search_result = Package.search(@search_term)
    @packages = @search_result.first

    if !@search_term.end_with?('~') && @search_result.size > 1
      flash[:notice] = "No packages were found for '#{@search_term}'. We tried a fuzzy search instead:"
    end

    @search_term.sub!(/~/, '')
  end
end
