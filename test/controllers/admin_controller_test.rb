require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    request.env['HTTP_REFERER'] = 'test'
  end

  test 'user search by email should return results for admin' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user, email: 'user@user.com')
    sign_in admin

    get :user_search, { term: 'user' }

    assert_select '#users .row', 1
  end

  test 'user search by phone should return results for admin' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user, phone: '1234567890')
    sign_in admin

    get :user_search, { term: '123456' }

    assert_select '#users .row', 1
  end

  test 'user search with no term should return all users' do
    admin = FactoryGirl.create(:user, role: 'admin')
    users = FactoryGirl.create_list(:user, 20)
    sign_in admin

    get :user_search

    assert_select '#users .row', 21
  end

  test 'normal user should not be able to search' do
    user = create_ready_user
    sign_in user

    assert_raises CanCan::AccessDenied do
      get :user_search
    end
  end

  test 'moderator should not be able to search' do
    user = create_ready_user
    user.update(role: 'moderator')

    assert_raises CanCan::AccessDenied do
      get :user_search
    end
  end

  test 'admin should be able to verify user' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user)
    sign_in admin

    get :verify, user_id: user.id

    user = User.find_by(role: 'poster')
    assert user.sms_confirmed
  end

  test 'admin should be able to promote user' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user)
    sign_in admin

    get :promote, user_id: user.id

    user = User.find_by(role: 'moderator')
    assert user
  end

  test 'admin should be able to demote user' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user, role: 'moderator')
    sign_in admin

    get :demote, user_id: user.id

    user = User.find_by(role: 'poster')
    assert user
  end

  test 'admin should be able to delete user' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user)
    sign_in admin

    delete :destroy_user, user_id: user.id

    user = User.find_by(role: 'poster')
    assert_nil user
  end

  test 'unconfirmed user row should not show promote button' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user)
    sign_in admin

    get :user_search

    assert_select '#users .row a.promote', 0
  end

  test 'should see delete button for user' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user)
    sign_in admin

    get :user_search

    assert_select '#users .row a.delete', 1
  end

  test 'should see promote button for verified user' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user, sms_confirmed: true)
    sign_in admin

    get :user_search

    assert_select '#users .row a.promote', 1
  end

  test 'should see demote button for moderator' do
    admin = FactoryGirl.create(:user, role: 'admin')
    user = FactoryGirl.create(:user, role: 'moderator', sms_confirmed: true)
    sign_in admin

    get :user_search

    assert_select '#users .row a.demote', 1
  end
end
