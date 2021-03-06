class Admin::CheckoutsController < Admin::ApplicationController
  include Concerns::Authenticable
  before_action :set_abandoned_checkout, only: [:show, :destroy]

  def index
    @abandoned_checkouts = current_shop.checkouts.abandoned_checkouts.page(params[:page])
  end

  def show
  end

  def destroy
    AdminServices::Checkout::DeleteCheckout
    .new(id: @abandoned_checkout.id)
    .run
    redirect_to admin_checkouts_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_abandoned_checkout
    @abandoned_checkout = current_shop.checkouts.abandoned_checkouts.find(params[:id])
  end
end
