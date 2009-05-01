class SearchController < ApplicationController
  def show
    @title = 'Search'
    @search_term = String(params[:q]).strip.downcase
    @packages = Package.search(@search_term)
    @search_term.sub!(/~/, '')
  end
end
