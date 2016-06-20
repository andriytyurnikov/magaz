require 'test_helper'

class AdminServices::Invite::CreateInviteTest < ActiveSupport::TestCase

  setup do
    @shop = create(:shop, name: 'shop_name')
    @email = 'some@email.com'
    @user = create(:user, shop: @shop)
    @url_building_proc = lambda {|user_object|
                                 "I'm generated by proc"}
  end

  test 'should create user and send invite with valid params' do
    assert_equal 1, User.count
    ActionMailer::Base.deliveries = []
    service = AdminServices::Invite::CreateInvite
              .run(email: @email,
                   shop_id: @shop.id,
                   url_building_proc: @url_building_proc)
    assert service.valid?
    assert_equal service.link, "I'm generated by proc"
    assert_equal 1, ActionMailer::Base.deliveries.count
    assert_equal 2, User.count
  end

  test 'should not create user and send invite with existing email' do
    ActionMailer::Base.deliveries = []
    assert_equal 1, User.count
    service = AdminServices::Invite::CreateInvite
              .run(email: @user.email,
                   shop_id: @shop.id,
                   url_building_proc: @url_building_proc)
    refute service.valid?
    assert_equal 1, User.count
    assert_equal 0, ActionMailer::Base.deliveries.count
  end

  test 'should not create user and send invite with blank params' do
    ActionMailer::Base.deliveries = []
    assert_equal 1, User.count
    service = AdminServices::Invite::CreateInvite
              .run(email: '',
                   shop_id: '',
                   url_building_proc: '')
    refute service.valid?
    assert_equal 1, User.count
    assert_equal 0, ActionMailer::Base.deliveries.count
    assert_equal 2, service.errors.count
    assert_equal "Shop is not a valid integer", service.errors.full_messages.first
    assert_equal "Url building proc is not a valid interface", service.errors.full_messages.last
  end
end
