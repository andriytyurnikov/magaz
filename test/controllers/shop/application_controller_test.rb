require 'test_helper'

class Shop::ApplicationControllerTest < ActionController::TestCase
  test 'helper methods defined' do
    assert @controller._helper_methods.include?(:shopping_cart)
  end
end