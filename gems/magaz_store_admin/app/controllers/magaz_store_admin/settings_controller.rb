module MagazStoreAdmin
  class SettingsController < ApplicationController
    include MagazCore::Concerns::Authenticable
    layout 'admin_settings'

    #Settings

    def edit
      @shop = current_shop
    end

    def update
      @shop = current_shop
      if @shop.update_attributes(permitted_params[:shop])
        flash[:notice] = t('.success_notice')
        render 'edit'
      else
        render 'edit'
      end
    end

    #Payments

    def payments_settings
      @shop = current_shop
    end

    def payments_settings_update
      if current_shop.update_attributes(permitted_params_for_payments[:shop])
        flash[:notice] = t('.success_notice')
        redirect_to payments_settings_settings_path
      else
        render "payments_settings"
      end
    end

    #Checkouts

    def checkouts_settings
      @shop = current_shop
    end

    def checkouts_settings_update
      if current_shop.update_attributes(permitted_params_for_checkouts[:shop])
        flash[:notice] = t('.success_notice')
        redirect_to checkouts_settings_settings_path
      else
        render "checkouts_settings"
      end
    end

    #Notifications

    def notifications_settings
      @shop = current_shop
    end

    def notifications_settings_update
      if current_shop.update_attributes(permitted_params_for_notifications[:shop])
        flash[:notice] = t('.success_notice')
        redirect_to notifications_settings_settings_path
      else
        render "notifications_settings"
      end
    end

    #Taxes

    DIGITAL_GOODS_VAT_TAX = "Digital Goods VAT Tax"

    def taxes_settings
      @shop = current_shop
      if @shop.eu_digital_goods_collection_id == nil
        @default_collection = @shop.collections.find_by(name: DIGITAL_GOODS_VAT_TAX)
      else
        @default_collection = @shop.eu_digital_goods_collection
      end
    end

    def taxes_settings_update
      if current_shop.update_attributes(permitted_params_for_taxes[:shop])
        flash[:notice] = t('.success_notice')
        unless params[:charge_vat_taxes]
          current_shop.update_attributes(eu_digital_goods_collection_id:  nil)
        end
        redirect_to taxes_settings_settings_path
      else
        render "taxes_settings"
      end
    end

    def enable_eu_digital_goods_vat_taxes
      if current_shop.collections.find_by(name: DIGITAL_GOODS_VAT_TAX) == nil
        @default_collection = current_shop.collections.new(name: DIGITAL_GOODS_VAT_TAX)
        if @default_collection.save
          current_shop.update_attributes(eu_digital_goods_collection_id:  @default_collection.id)
          redirect_to taxes_settings_settings_path
        else
          current_shop.update_attributes(eu_digital_goods_collection_id:  false)
          redirect_to taxes_settings_settings_path
        end
      else
        @default_collection = current_shop.collections.find_by(name: DIGITAL_GOODS_VAT_TAX)
        current_shop.update_attributes(eu_digital_goods_collection_id:  @default_collection.id)
        redirect_to taxes_settings_settings_path
      end
    end

    def set_default_collection
      @shop = current_shop
      @default_collection = current_shop.eu_digital_goods_collection
      @collections = current_shop.collections.page(params[:page])
    end

    def save_default_collection
      @default_collection = current_shop.collections.find_by_id(params[:default_collection])
      current_shop.update_attributes(eu_digital_goods_collection_id:  @default_collection.id)
      redirect_to taxes_settings_settings_path
    end

    protected

    def permitted_params
      { shop:
          params.fetch(:shop, {}).permit(:name, :address, :business_name,
                                         :city, :country, :currency, :customer_email,
                                         :phone, :province, :timezone, :unit_system,
                                         :zip, :handle, :page_title, :meta_description) }
    end

    def permitted_params_for_checkouts
      { shop:
          params.fetch(:shop, {}).permit(:account_type_choice, :billing_address_is_shipping_too,
                                        :abandoned_checkout_time_delay, :email_marketing_choice,
                                        :after_order_paid, :after_order_fulfilled_and_paid,
                                        :checkout_language, :checkout_refund_policy,
                                        :checkout_privacy_policy, :checkout_term_of_service,
                                        :enable_multipass_login, :notify_customers_of_their_shipment,
                                        :automatically_fulfill_all_orders) }
    end

    def permitted_params_for_payments
      { shop:
        params.fetch(:shop, {}).permit(:authorization_settings)}
    end

    def permitted_params_for_taxes
      { shop:
          params.fetch(:shop, {}).permit(:all_taxes_are_included, :charge_taxes_on_shipping_rates) }
    end
  end
end