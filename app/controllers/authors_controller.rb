class AuthorsController < ApplicationController

  resource_controller

  actions :index, :show # Only index and show for Authors

  show.failure.wants.html do
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

end
