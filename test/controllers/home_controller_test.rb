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
end
