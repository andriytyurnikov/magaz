require 'test_helper'

class MagazCore::ShopServices::Blog::ChangeBlogTest < ActiveSupport::TestCase

  setup do
    @shop = create(:shop, name: 'shop_name')
    @blog = create(:blog, shop: @shop)
    @blog2 = create(:blog, shop: @shop)
    @success_params = { id: @blog.id, title: "Changed title", shop_id: @shop.id,
                        page_title: "Changed page_title", handle: "Changed handle",
                        meta_description: "Changed meta_description" }
  end

  test 'should update blog with valid params' do
    service = MagazCore::ShopServices::Blog::ChangeBlog.run(@success_params)
    assert service.valid?
    assert_equal "Changed page_title", MagazCore::Blog.find(@blog.id).page_title
    assert_equal 'Changed title', MagazCore::Blog.find(@blog.id).title
    assert_equal "Changed handle", MagazCore::Blog.find(@blog.id).handle
  end

  test 'should not update blog with existing title' do
    service = MagazCore::ShopServices::Blog::ChangeBlog.
                run(id: @blog.id, title: @blog2.title, shop_id: @shop.id,
                    page_title: "Changed page_title", handle: "ChangedC handle",
                    meta_description: "Changed meta_description")
    refute service.valid?
    assert_equal 1, service.errors.full_messages.count
    assert_equal "Title has already been taken", service.errors.full_messages.first
  end

  test 'should update blog with some blank params' do
    service = MagazCore::ShopServices::Blog::ChangeBlog.
                run(id: @blog2.id, title: @blog2.title, shop_id: @shop.id,
                    page_title: "", handle: "", meta_description: "")
    assert service.valid?
    assert_equal '', service.result.handle
    assert_equal '', service.result.page_title
  end
end