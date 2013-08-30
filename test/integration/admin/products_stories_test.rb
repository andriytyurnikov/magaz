require 'test_helper'

class Admin::ProductsStoriesTest < ActionDispatch::IntegrationTest
  setup do 
    login_as shop_name: 'Example',
      email: 'admin@example.com',
      password: 'password'
    click_link 'Products'
  end

  test "products list" do
    assert page.has_content? 'Products'
    assert page.has_content? 'Product 1'
  end

  test "create product" do
    click_link 'New Product'
    fill_in 'Name', with: 'Some Product'
    fill_in 'Description', with: 'Some Description'
    click_button 'Create Product'
    assert page.has_content? 'Product was successfully created.'
  end

  test "create product failure" do
    click_link 'New Product'
    fill_in 'Name', with: ''
    fill_in 'Description', with: ''
    click_button 'Create Product'
    assert page.has_content? '2 errors prohibited this product from being saved'
  end

  test 'create product - set product type' do
    # fail creation without product type?
    # manage product types?
    skip
  end

  test 'create/update product - set product vendor' do
    skip
  end

  test 'create/update product - set product images' do
    skip
  end

  test 'create/update product - set collection membership' do
    skip
  end

  test 'create/update product - set tags' do
    skip
  end

  test 'create/update product - set invisible' do
    skip
  end

  test "edit product" do
    click_link('Show', match: :first)
    fill_in 'Name', with: 'Some Product'
    fill_in 'Description', with: 'Some Description'
    click_button 'Update Product'
    assert page.has_content? 'Product was successfully updated.'
  end
 
  test "delete product" do
    click_link('Destroy',match: :first)
    refute page.has_content? 'Product 1'
  end
end