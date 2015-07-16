require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  include Devise::TestHelpers

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

  test 'user search by email should return results for moderator' do
    mod = FactoryGirl.create(:user, role: 'moderator', sms_confirmed: true)
    user = FactoryGirl.create(:user, email: 'user@user.com')
    sign_in mod

    get :user_search, { term: 'user' }

    assert_select '#users .row', 1
  end
  
  test 'normal user should not be able to search' do
    user = create_ready_user
    sign_in user

    assert_raises CanCan::AccessDenied do
      get :user_search
    end
  end
end
