require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @shop = create(:shop, subdomain: 'example')
    session_for_shop @shop
    @user = create(:user, shop: @shop)
  end

   test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('MagazCore::User.count') do
      post :create, { user: { email: "staff_user@example.com",
                              first_name: "First Name",
                              last_name: "Last Name",
                              password: "qwerty"} }
    end

    assert_redirected_to admin_user_path(assigns(:user))
  end

  test "should show product" do
    get :show,
      id: @user
    assert_response :success
  end

  test "should update product" do
    patch :update,
      { id: @user.id,
        user: { first_name: @user.first_name, last_name: @user.last_name,
                email: @user.email, password: @user.password  } }
    assert_redirected_to admin_user_path(assigns(:user))
  end

  test "should not update product" do
    patch :update,
      { id: @user.id,
        user: { first_name: ' ' , last_name: ' ',
                email: ' ', password: ' '  } }
    assert_template :show
    assert_response :success
  end

  test "should destroy product" do
    assert_difference('MagazCore::User.count', -1) do
      delete :destroy, id: @user.id
    end

  assert_redirected_to admin_users_path
  end
end
