module MagazStoreAdmin
  class ShippingRatesController < ApplicationController
    include MagazCore::Concerns::Authenticable
    layout 'admin_settings'

    def index
      @shipping_country = current_shop.shipping_countries.find(params[:shipping_country_id])
      @shipping_rates = @shipping_countries.shipping_rates.page(params[:page])
    end

    def show
      @shipping_country = current_shop.shipping_countries.find(params[:shipping_country_id])
      @shipping_rate = @shipping_country.shipping_rates.find(params[:id])
    end

    def new
      @shipping_country = current_shop.shipping_countries.find(params[:shipping_country_id])
      @shipping_rate = @shipping_country.shipping_rates.new
    end

    def create
      @shipping_country = current_shop.shipping_countries.find(params[:shipping_country_id])
      service = MagazCore::AdminServices::ShippingRate::AddShippingRate
                  .run(name: params[:shipping_rate][:name],
                       shipping_country_id: @shipping_country.id,
                       criteria: params[:shipping_rate][:criteria],
                       price_to: params[:shipping_rate][:price_to],
                       weight_to: params[:shipping_rate][:weight_to],
                       price_from: params[:shipping_rate][:price_from],
                       weight_from: params[:shipping_rate][:weight_from],
                       shipping_price: params[:shipping_rate][:shipping_price])
      if service.valid?
        @shipping_rate = service.result
        flash.now[:notice] = t('.notice_success')
        render 'show'
      else
        @shipping_rate = MagazCore::ShippingRate.new
        service.errors.full_messages.each do |msg|
          @shipping_rate.errors.add(:base, msg)
        end
        render 'new'
      end
    end

    def update
      @shipping_country = current_shop.shipping_countries.find(params[:shipping_country_id])
      @shipping_rate = @shipping_country.shipping_rates.find(params[:id])
      service = MagazCore::AdminServices::ShippingRate::ChangeShippingRate
                  .run(id: @shipping_rate.id,
                       name: params[:shipping_rate][:name],
                       criteria: params[:shipping_rate][:criteria],
                       price_to: params[:shipping_rate][:price_to],
                       weight_to: params[:shipping_rate][:weight_to],
                       price_from: params[:shipping_rate][:price_from],
                       weight_from: params[:shipping_rate][:weight_from],
                       shipping_price: params[:shipping_rate][:shipping_price])
      if service.valid?
        @shipping_rate = service.result
        flash[:notice] = t('.notice_success')
        redirect_to shipping_country_shipping_rate_path
      else
        flash.now[:notice] = t('.notice_fail')
        service.errors.full_messages.each do |msg|
          @shipping_rate.errors.add(:base, msg)
        end
        render 'show'
      end
    end

    def destroy
      @shipping_country = current_shop.shipping_countries.find(params[:shipping_country_id])
      @shipping_rate = @shipping_country.shipping_rates.find(params[:id])
      service = MagazCore::AdminServices::ShippingRate::DeleteShippingRate
                  .run(id: @shipping_rate.id,
                       shipping_country_id: @shipping_country.id)
      flash[:notice] = t('.notice_success')
      redirect_to shipping_country_path(@shipping_country)
    end
  end
end
