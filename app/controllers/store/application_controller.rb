class Store::ApplicationController < ApplicationController
  layout 'store'
  helper_method :shopping_cart

  around_action :set_shopping_cart

  def current_shop
    Shop.find_by_subdomain(request.subdomain)
  end

  def shopping_cart
    @shopping_cart
  end

  def set_shopping_cart
    @shopping_cart = if session[:cart_id].blank?
      current_shop.orders.create
    else
      Order.find_by_id(session[:cart_id]) || current_shop.orders.create
    end
     
    yield
    session[:cart_id] = @shopping_cart.id
    @shopping_cart.save
  end
  
end
