class ActionController::Base

  # From http://raindroprecords.blogspot.com/2009/02/post-request-in-rails.html
  def redirect_post(redirect_post_params)
    controller_name = redirect_post_params[:controller]
    controller = "#{controller_name.camelize}Controller".constantize
    # Throw out existing params and merge the stored ones
    request.parameters.reject! { true }
    request.parameters.merge!(redirect_post_params)
    controller.process(request, response)
    if response.redirected_to
      @performed_redirect = true
    else
      @performed_render = true
    end
  end

end
