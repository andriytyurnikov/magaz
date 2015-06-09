module MagazStoreAdmin
  class CustomersController < ApplicationController
    include MagazCore::Concerns::Authenticable
    respond_to :csv

    def index
      @customers = current_shop.customers.page(params[:page])
    end

    def show
      @customer = current_shop.customers.find(params[:id])
    end

    def new
      @customer = current_shop.customers.new
    end

    def create
      @customer = current_shop.customers.new(permitted_params[:customer])
      if @customer.save
        @event_service = MagazCore::ShopServices::CreateEvent.call(subject: @customer,
                                                                   message: I18n.t('magaz_store_admin.events.message', action: t('.created'), subject: t('.customer'), user_name: current_user.full_name),
                                                                   verb: t('.create'))
        @webhook_service = MagazCore::ShopServices::EventWebhookRunner.call(event: @event_service.event,
                                                                            webhook: "create_customer_event")
        flash[:notice] = t('.notice_success')
        redirect_to customer_path(@customer)
      else
        render 'new'
      end
    end

    def update
      @customer = current_shop.customers.find(params[:id])
      if @customer.update_attributes(permitted_params[:customer])
        @event_service = MagazCore::ShopServices::CreateEvent.call(subject: @customer,
                                                                   message: I18n.t('magaz_store_admin.events.message', action: t('.updated'), subject: t('.customer'), user_name: current_user.full_name),
                                                                   verb: t('.update'))
        @webhook_service = MagazCore::ShopServices::EventWebhookRunner.call(event: @event_service.event,
                                                                            webhook: "update_customer_event")
        flash[:notice] = t('.notice_success')
        redirect_to customer_path(@customer)
      else
        render 'show'
      end
    end

    def import
      MagazCore::ShopServices::ImportCustomersFromCsv.call(shop_id: current_shop.id, csv_file: params[:csv_file])
      redirect_to customers_path, notice: t('.notice_success')
    end

    def export
      @customers = current_shop.customers.all
      respond_to do |format|
        format.html
        format.csv { send_data @customers.to_csv, :type => "text/csv", :disposition => "attachment; filename=сustomers.csv" }
      end
    end

    def destroy
      @customer = current_shop.customers.find(params[:id])
      @customer.destroy
      @event_service = MagazCore::ShopServices::CreateEvent.call(subject: @customer,
                                                                 message: I18n.t('magaz_store_admin.events.message', action: t('.deleted'), subject: t('.customer'), user_name: current_user.full_name),
                                                                 verb: t('.destroy'))
      @webhook_service = MagazCore::ShopServices::EventWebhookRunner.call(event: @event_service.event,
                                                                          webhook: "delete_customer_event")
      flash[:notice] = t('.notice_success')
      redirect_to customers_path
    end

    protected

    #TODO:  collection_ids are not guaranteed to belong to this shop!!!
    # https://github.com/josevalim/inherited_resources#strong-parameters
    def permitted_params
      { customer:
          params.fetch(:customer, {}).permit(:first_name, :last_name, :email) }
    end
  end
end
