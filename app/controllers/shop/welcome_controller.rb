class Shop::WelcomeController < Shop::ApplicationController
  def index
    @collections = current_shop.collections
  end
end