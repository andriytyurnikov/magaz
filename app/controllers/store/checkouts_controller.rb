module Store
  class CheckoutsController < Store::ApplicationController
    # inherit_resources
    # actions :show, :update

    def update_address
      service = StoreServices::ShoppingCart::UpdateAddress.new(shop_id:       current_shop.id,
                                                               checkout_id:   session[:checkout_id],
                                                               customer_id:   session[:customer_id],
                                                               address_attrs: permitted_params_update_address[:checkout])
                                                           .run
      if service.success?
        redirect_to enter_payment_checkout_path(service.checkout)
      else
        render :show
      end
    end

    def enter_payment
      resource
    end

    def pay
      if shopping_cart_service.checkout_to_order(permitted_params_order[:checkout])
        redirect_to order_path(resource)
      else
        render :enter_payment
      end
    end

    protected

    def begin_of_association_chain
      current_shop
    end

    def resource
      shopping_cart_service.checkout
    end

    def permitted_params_update_address
      { checkout: params.fetch(:checkout, {}).permit(:email) }
    end

    def permitted_params_order
      { checkout: params.fetch(:checkout, {}).permit(:email) }
    end
  end
end
