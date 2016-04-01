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
      @customer = MagazCore::AdminServices::Customer::AddCustomer.new
    end

    def create
      service = MagazCore::AdminServices::Customer::AddCustomer
                  .run(first_name: params[:customer][:first_name],
                       last_name: params[:customer][:last_name],
                       email: params[:customer][:email],
                       shop_id: current_shop.id)

      if service.valid?
        # @webhook_service = MagazCore::AdminServices::EventWebhookRunner.call(event: @event_service.event,
        #                         topic: MagazCore::Webhook::Topics::CREATE_CUSTOMER_EVENT)
        @customer = service.result
        flash[:notice] = t('.notice_success')
        redirect_to customer_path(@customer)
      else
        @customer = service
        flash[:notice] = t('.notice_fail')
        render 'new'
      end
    end

    def update
      @customer = current_shop.customers.find(params[:id])
      service = MagazCore::AdminServices::Customer::ChangeCustomer
                  .run(id: @customer.id,
                       first_name: params[:customer][:first_name],
                       last_name: params[:customer][:last_name],
                       email: params[:customer][:email],
                       shop_id: current_shop.id)
      if service.valid?
        # @webhook_service = MagazCore::AdminServices::EventWebhookRunner.call(event: @event_service.event,
        #                         topic: MagazCore::Webhook::Topics::UPDATE_CUSTOMER_EVENT)
        @customer = service.result
        flash[:notice] = t('.notice_success')
        redirect_to customer_path(@customer)
      else
        @customer = service
        flash[:notice] = t('.notice_fail')
        render 'show'
      end
    end

    def import
      MagazCore::AdminServices::Customer::ImportCustomersFromCsv
        .call(shop_id: current_shop.id, csv_file: params[:csv_file])

      redirect_to customers_path, notice: t('.notice_success')
    end

    def export
      @customers = current_shop.customers.all
      respond_to do |format|
        format.html
        format.csv { send_data @customers.to_csv, :type => "text/csv",
                     :disposition => "attachment; filename=сustomers.csv" }
      end
    end

    def destroy
      @customer = current_shop.customers.find(params[:id])
      service = MagazCore::AdminServices::Customer::DeleteCustomer.run(id: @customer.id)
      # @webhook_service = MagazCore::AdminServices::EventWebhookRunner
        #.call(event: @event_service.event, topic: MagazCore::Webhook::Topics::DELETE_CUSTOMER_EVENT)
      flash[:notice] = t('.notice_success')
      redirect_to customers_path
    end
  end
end
