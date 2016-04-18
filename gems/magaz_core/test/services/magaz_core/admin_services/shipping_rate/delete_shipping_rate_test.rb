require 'test_helper'

class MagazCore::AdminServices::ShippingRate::DeleteShippingRateTest < ActiveSupport::TestCase

  setup do
    @shop = create(:shop, name: 'shop_name')
    @shipping_country = create(:shipping_country, shop: @shop)
    @first_shipping_rate = create(:shipping_rate, shipping_country: @shipping_country)
    @second_shipping_rate = create(:shipping_rate, shipping_country: @shipping_country)
  end

  test 'should delete shipping rate with valid id' do
    assert_equal 2, @shipping_country.shipping_rates.count
    service = MagazCore::AdminServices::ShippingRate::DeleteShippingRate.run(id: @first_shipping_rate.id)
    assert service.valid?
    refute MagazCore::ShippingRate.find_by_id(@first_shipping_rate.id)
    assert MagazCore::ShippingRate.find_by_id(@second_shipping_rate.id)
    assert_equal 1, @shipping_country.shipping_rates.count
  end

  test 'should not delete shipping rate with blank id' do
    assert_equal 2, @shipping_country.shipping_rates.count
    service = MagazCore::AdminServices::ShippingRate::DeleteShippingRate.run(id: "")
    refute service.valid?
    assert_equal 2, @shipping_country.shipping_rates.count
  end
end
