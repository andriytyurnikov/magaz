require 'test_helper'

class Store::BrowsingStoriesTest < ActionDispatch::IntegrationTest
  setup do
    set_subdomain(@shop.subdomain)
    @collection = create(:collection, shop: @shop, name: 'Frontpage')
    @product = create(:product, shop: @shop, collections: [@collection])
  end

  test "index page" do
    visit '/'
    assert page.has_content? @product.name
  end

  test "product page" do
    visit '/'
    click_link @product.name
    
    assert page.has_content? @product.name
    assert page.has_content? @product.description
    assert page.has_selector? "input[type=submit][value='Purchase']"
  end

  test "collection page" do
    skip
  end

  test "navigation" do
    skip
  end
end