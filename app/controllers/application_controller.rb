class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  helper_method :current_shop

  protected
  
  def current_shop
    @current_shop ||= Shop.find_by_subdomain(request.subdomain)
  end

end
