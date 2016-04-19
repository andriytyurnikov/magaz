require 'test_helper'
class MagazCore::AdminServices::ShippingRate::AddShippingRateTest < ActiveSupport::TestCase

  setup do
    @shop = create(:shop, name: "New shop")
    @shipping_country = create(:shipping_country, shop: @shop)
    @succsess_params = {name: "Test name",
                        price_to: "20.5",
                        weight_to: "5.5",
                        shipping_price: 5,
                        criteria: "weight",
                        price_from: "15.7",
                        weight_from: "3.1",
                        shipping_country_id: @shipping_country.id}
    @blank_params = {name: "",
                     price_to: "",
                     weight_to: "",
                     shipping_price: "",
                     criteria: "",
                     price_from: "",
                     weight_from: "",
                     shipping_country_id: ""}
  end

  test "should add shipping rate with valid params" do
    assert_equal 0, MagazCore::ShippingRate.count
    service = MagazCore::AdminServices::ShippingRate::AddShippingRate.run(@succsess_params)
    assert service.valid?
    assert MagazCore::ShippingRate.find(service.result.id)
    assert_equal 1, MagazCore::ShippingRate.count
    assert_equal @succsess_params[:name], MagazCore::ShippingRate.find(service.result.id).name
  end

  test "should not add shipping rate with blank params" do
    assert_equal 0, MagazCore::ShippingRate.count
    service = MagazCore::AdminServices::ShippingRate::AddShippingRate.run(@blank_params)
    refute service.valid?
    assert_equal 2, service.errors.full_messages.count
    assert_equal "Shipping price is not a valid float", service.errors.full_messages.first
    assert_equal "Shipping country is not a valid integer", service.errors.full_messages.last
    assert_equal 0, MagazCore::ShippingRate.count
  end

  test "shoul add shipping rate with some blank params" do
    @succsess_params[:weight_from] = ""
    @succsess_params[:weight_to] = ""
    @succsess_params[:price_from] = ""
    @succsess_params[:price_to] = ""
    assert_equal 0, MagazCore::ShippingRate.count
    service = MagazCore::AdminServices::ShippingRate::AddShippingRate.run(@succsess_params)
    assert service.valid?
    assert MagazCore::ShippingRate.find(service.result.id)
    assert_equal 1, MagazCore::ShippingRate.count
    assert_equal @succsess_params[:name], MagazCore::ShippingRate.find(service.result.id).name
    assert_equal nil, MagazCore::ShippingRate.find(service.result.id).price_from
  end

  test "should not add shipping rate with wrong criteria" do
    assert_equal 0, MagazCore::ShippingRate.count
    service = MagazCore::AdminServices::ShippingRate::AddShippingRate
                .run(name: "Test name",
                     price_to: "20.5",
                     weight_to: "",
                     shipping_price: 5,
                     criteria: "weight",
                     price_from: "0.15",
                     weight_from: "",
                     shipping_country_id: @shipping_country.id)
    refute service.valid?
    assert_equal 1, service.errors.full_messages.count
    assert_equal "Criteria is not correct", service.errors.full_messages.first
    assert_equal 0, MagazCore::ShippingRate.count
  end

  test "should not add shipping rate with wrong comparison" do
    assert_equal 0, MagazCore::ShippingRate.count
    service = MagazCore::AdminServices::ShippingRate::AddShippingRate
                .run(name: "Test name",
                     price_to: "",
                     weight_to: "5.5",
                     shipping_price: 5,
                     criteria: "weight",
                     price_from: "",
                     weight_from: "10.7",
                     shipping_country_id: @shipping_country.id)
    refute service.valid?
    assert_equal 1, service.errors.full_messages.count
    assert_equal "weight_to must be greater than weight_from", service.errors.full_messages.first
    assert_equal 0, MagazCore::ShippingRate.count
  end

  test "should not add shipping rate with wrong weight" do
    assert_equal 0, MagazCore::ShippingRate.count
    service = MagazCore::AdminServices::ShippingRate::AddShippingRate
                .run(name: "Test name",
                     price_to: "",
                     weight_to: "some",
                     shipping_price: 5,
                     criteria: "weight",
                     price_from: "",
                     weight_from: "text",
                     shipping_country_id: @shipping_country.id)
    refute service.valid?
    assert_equal 2, service.errors.full_messages.count
    assert_equal "Weight from is not correct", service.errors.full_messages.first
    assert_equal "Weight to is not correct", service.errors.full_messages.last
    assert_equal 0, MagazCore::ShippingRate.count
  end
end