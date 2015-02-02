require 'test_helper'

class SignupStoriesTest < ActionDispatch::IntegrationTest
  setup do
    use_host HOSTNAME
    @default_theme = build(:theme)
    archive_path = ::File.expand_path("#{Rails.root}/test/fixtures/files/valid_theme.zip", __FILE__)
    MagazCore::ThemeServices::ImportFromArchive
      .call(archive_path: archive_path,
            theme: @default_theme,
            theme_attributes: { name: 'Default' })
  end

  test "signup success" do
    visit '/'
    assert page.has_content?('Welcome')

    fill_in 'Your shop name', with: 'Example2'
    fill_in 'Email address', with: 'uniq@example2.com'
    fill_in 'Password', with: 'password'
    click_button 'Create your shop now'

    assert page.has_content?('Dashboard')
  end

  test "signup failure" do
    visit '/'
    assert page.has_content?('Welcome')

    fill_in 'Your shop name', with: ''
    fill_in 'Email address', with: ''
    fill_in 'Password', with: ''
    click_button 'Create your shop now'
    assert page.has_content?('Welcome')
  end

  test "signup redirect and signup success" do
    visit '/registration'
    fill_in 'Your shop name', with: 'Example3'
    fill_in 'Email address', with: 'uniq@example3.com'
    fill_in 'Password', with: 'password'
    click_button 'Create your shop now'

    assert page.has_content?('Dashboard')
  end
end
