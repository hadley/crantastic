class AuthorsController < ApplicationController

  resource_controller

  actions :index, :show # Only index and show for Authors

  show.failure.wants.html { rescue_404 }

end
