class SessionsController < ApplicationController
  respond_to :html

  def new
  end

  def show
    render :new
  end

  #TODO:  test user not found case
  def create
    @shop = Shop.find_by(subdomain: params[:session][:subdomain])
    @user = @shop.users.find_by_email(params[:session][:email].downcase)

    if @shop && @user && @user.authentic_password?(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to admin_index_url(host: HOSTNAME, subdomain: @shop.subdomain)
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
