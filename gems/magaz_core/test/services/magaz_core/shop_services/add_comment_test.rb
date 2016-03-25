require 'test_helper'

module MagazCore
  class ShopServices::AddCommentTest < ActiveSupport::TestCase

    setup do 
      @shop = create(:shop, name: 'shop_name')
      @blog = create(:blog, shop: @shop)
      @article = create(:article, blog: @blog)
      @blog2 = create(:blog, shop: @shop)
      @article2 = create(:article, blog: @blog2)
      @success_params = {author: "Test author", email: "Test test@test.com", body: "Test body",
                         article_id: @article.id, blog_id: @blog.id}
      @blank_params = {author: "", email: "", body: "", article_id: nil, blog_id: nil}
    end

    test 'should create comment with valid params' do
      service = MagazCore::ShopServices::AddComment.run(@success_params)
      assert service.valid?
      assert MagazCore::Comment.find_by_id(service.result.id)
      assert_equal 'Test author', service.result.author
      assert_equal 1, MagazCore::Article.find_by_id(@article.id).comments.count
    end

    test 'should not create comment for article that belongs to another blog' do
      service = MagazCore::ShopServices::AddComment.run(author: "Test author", email: "Test test@test.com", body: "Test body",
                         article_id: @article2.id, blog_id: @blog.id)
      refute service.valid?
      assert_equal 0, MagazCore::Article.find_by_id(@article.id).comments.count
      assert_equal 1, service.errors.full_messages.count
      assert_equal "This article is not belongs to blog", service.errors.full_messages.last
    end

    test 'should not create comment with blank params' do
      service = MagazCore::ShopServices::AddComment.run(@blank_params)
      refute service.valid?
      assert_equal 2, service.errors.full_messages.count
      assert_equal 0, MagazCore::Article.find_by_id(@article.id).comments.count
    end

  end
end