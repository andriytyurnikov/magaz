class ActionDispatch::IntegrationTest 
  # private
  module CustomIntegrationDsl
    def use_js
      Capybara.current_driver = Capybara.javascript_driver
    end

    def set_host (host)
      host! host
      Capybara.app_host = "http://" + host + ":" + parallel_capybara_server_port.to_s
      Capybara.default_host = Capybara.app_host
    end

    def set_subdomain(subdomain)
      set_host("#{subdomain}.#{HOSTNAME}")
    end

    def login_as(shop_name: nil, email: nil, password: nil)
      use_js
      set_host HOSTNAME
      visit '/'
      click_link 'Sign in'
      fill_in 'Your shop name', with: shop_name
      fill_in 'Email address', with: email
      fill_in 'Password', with: password
      
      set_subdomain shop_name
      click_button 'Sign in'
    end
  end

  include CustomIntegrationDsl
end

class ActionController::TestCase
  private
  module CustomControllerDsl
    def session_for_shop(shop)
      session[:user_id] = shop.id
      controller_with_subdomain(shop.subdomain)
    end

    def controller_with_subdomain(subdomain)
      request.host = subdomain + '.' + HOSTNAME
    end
  end

  include CustomControllerDsl
end