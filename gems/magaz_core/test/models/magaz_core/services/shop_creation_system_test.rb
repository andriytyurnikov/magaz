require 'test_helper'

module MagazCore
  class Services::ShopCreationSystemTest < ActiveSupport::TestCase
    setup do
      @default_theme = build(:theme)
      archive_path = File.expand_path('./../../../../fixtures/files/valid_theme.zip', __FILE__)
      Services::ThemeSystem::ArchiveImporter
        .new(archive_path: archive_path, 
             theme: @default_theme,
             theme_attributes: { name: 'Default' })
        .import
      @service = Services::ShopCreationSystem.new()
      @shop_params = { name: 'example42', email: 'admin@example42.com', password: 'secret' }
    end

    test 'create shop with valid params' do
      @service.create(@shop_params)
      assert @service.shop.persisted?
      refute @service.shop.themes.current.blank?
      assert_equal @default_theme, @service.shop.themes.current.first.source_theme
    end

    test 'fail shop creation when no default theme in system' do
      @default_theme.delete
      @service.create(@shop_params)
      refute @service.shop.persisted?
    end

    test 'fail shop creation when no shop params' do
      @service.create({})
      refute @service.shop.persisted?
    end
  end
end