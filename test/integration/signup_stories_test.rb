require 'test_helper'

class SignupStoriesTest < ActionDispatch::IntegrationTest  
  test "signup success" do
  	visit '/'
  	assert page.has_content?('Welcome')

  	fill_in 'Your shop name', with: 'Example'
  	fill_in 'Email address', with: 'uniq2@example.com'
  	fill_in 'Password', with: 'password'
  	click_button 'Create your shop now'

  	assert page.has_content?('Welcome to dashboard')
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
    fill_in 'Your shop name', with: 'Example'
    fill_in 'Email address', with: 'uniq2@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Create your shop now'

    assert page.has_content?('Welcome to dashboard')
  end
end
