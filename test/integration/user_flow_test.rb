require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  test 'sign up new user' do
    visit new_user_registration_path

    fill_in 'Email', with: 'user@user.com'
    fill_in 'Phone', with: '1234567890'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    click_button 'Sign up'

    assert has_content? I18n.t 'msg.please_confirm'
  end

  test 'sign in and verify new user' do
    user = FactoryGirl.create(:user)

    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'

    assert has_content? I18n.t 'msg.please_confirm'

    visit edit_user_registration_path
    fill_in 'user_sms_code', with: user.sms_code
    click_button 'Verify Account'

    assert has_content? I18n.t 'msg.confirmed'
  end

  test 'display forum list after generation' do
    user = FactoryGirl.create(:user, sms_confirmed: true, zip_code: nil)
    login user

    visit edit_user_registration_path
    fill_in 'user_zip_code', with: '12345'
    click_button 'Update'

    assert has_content? I18n.t 'msg.forums_created'

    visit forums_path
    assert has_content? 'New York'
    assert has_css? '#forums li', count: 5
  end

  # TODO: figure how to make Selenium accept geolocation request
  test 'get location from browser' do
    user = FactoryGirl.create(:user, sms_confirmed: true, zip_code: nil)
    login user

    visit edit_user_registration_path
    click_button 'get_location'
  end

  test 'search for forums' do
    user = create_ready_user(login=false)
    login user

    visit forums_path
    fill_in 'term', with: 'new york'
    click_button 'Search'

    assert has_css? '#forums li'    
  end

  test 'create a post' do
    user = create_ready_user(login=false)
    login user

    visit forum_path Forum.first
    click_link I18n.t 'links.create_post'

    fill_in 'post_subject', with: 'subject'
    fill_in 'post_body', with: 'body'
    click_button 'Create Post'

    assert has_content? Post.first.subject
    assert has_content? Post.first.body
  end

  test 'create a comment' do
    user = create_user_with_post(login=false)
    login user

    visit post_path Post.first
    fill_in 'comment_body', with: 'comment'
    click_button 'Create Comment'

    assert has_content? Comment.first.body
  end

  test 'upvote a post' do
    user = create_user_with_post(login=false)
    login user

    visit post_path Post.first
    click_link 'upvote_post_%d' % Post.first.id
    assert has_css? '.post .voted'
  end

  test 'upvote a comment' do
    user = create_user_with_comment(login=false)
    login user

    visit post_path Comment.first.post
    click_link 'upvote_comment_%d' % Comment.first.id
    assert has_css? '.comment .voted'
  end
end
