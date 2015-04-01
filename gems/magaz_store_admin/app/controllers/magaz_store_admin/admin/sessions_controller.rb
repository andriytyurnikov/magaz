module MagazStoreAdmin 
module MagazStoreAdmin
  class Admin::SessionsController < Admin::ApplicationController
    #TODO: layout
    respond_to :html

    def new
    end

    def show
      render :new
    end

    #TODO:  test user not found case
    def create
      @user = current_shop.users.find_by_email(params[:session][:email].downcase)

      if @user &&
        (@user.email == params[:session][:email].downcase) &&
         @user.authentic_password?(params[:session][:password])
        # valid login
        session[:user_id] = @user.id
        redirect_to admin_root_url(host: HOSTNAME, subdomain: current_shop.subdomain)
      else
        flash[:notice] = t('.notice')
        render :new
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to goodbye_url
    end
  end
end
end
