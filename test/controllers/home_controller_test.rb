require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'should show dashboard' do
    user = FactoryGirl.create(:user)

    sign_in user

    get :dashboard
    assert_select 'h3', I18n.t('headers.your_approved_posts')
  end

  test 'should redirect to home if not logged in' do
    get :dashboard
    assert_redirected_to new_user_session_path
  end

  test 'should show moderator dashboard' do
    user = FactoryGirl.create(:user, role: 'moderator')

    sign_in user

    get :dashboard
    assert_select 'h3', I18n.t('headers.mod_pending_posts')
  end

  test 'should show admin dashboard' do
    user = FactoryGirl.create(:user, role: 'admin')

    sign_in user

    get :dashboard
    assert_select 'h3', I18n.t('headers.find_user')
  end

  test 'should show active about link on nav' do
    get :about
    assert_select 'li.active a[href=?]', about_path
  end

  test 'should show inactive about link on nav' do
    user = FactoryGirl.create(:user)
    sign_in user
    
    r = get :dashboard
    assert_select 'li.active a[href=?]', about_path, false
  end

  test 'should show approved posts' do
    user = create_user_with_approved_post

    get :dashboard
    assert_select '#approved_posts li', 1
  end

  test 'should show pending posts' do
    user = create_user_with_post

    get :dashboard
    assert_select '#pending_posts li', 1
  end

  test 'admin should see unverified users' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user)
    
    sign_in admin

    get :dashboard

    assert_select '#pending_users li', 1
  end

  test 'non-admin should not see unverified users' do
    user = create_ready_user

    get :dashboard

    assert_select '#pending_users', 0
  end

  test 'admin should see search field' do
    admin = FactoryGirl.create(:user, role: 'admin')
    sign_in admin

    get :dashboard

    assert_select '#user_search_form'
  end

  test 'moderator should see search field' do
    mod = FactoryGirl.create(:user, role: 'moderator', sms_confirmed: true)
    sign_in mod

    get :dashboard

    assert_select '#user_search_form'
  end

  test 'normal user should not see search field' do
    user = create_ready_user

    get :dashboard

    assert_select '#user_search_form', 0
  end
end
