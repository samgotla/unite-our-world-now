require 'test_helper'

class ForumsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'logged in user should see their forums' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user)
    sign_in user

    get :index
    assert_select '#forums li', 5
  end

  test 'anonymous user should be redirected' do
    get :index
    assert_redirected_to new_user_session_path
  end

  test 'unconfirmed user should be redirected' do
    user = FactoryGirl.create(:user)
    sign_in user
    get :index
    assert_redirected_to edit_user_registration_path
  end

  test 'logged in user should see forum title' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user)
    sign_in user

    get :show, id: user.forum_id
    assert_select 'h3', user.forum.name
  end

  test 'should show children' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user)
    sign_in user

    get :children, id: user.forum.parent.id
    assert_select '#forums li', 1
  end
end
