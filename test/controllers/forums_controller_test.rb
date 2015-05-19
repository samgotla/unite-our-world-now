require 'test_helper'

class ForumsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'logged in user should see a forum' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    forum = FactoryGirl.create(:forum)
    sign_in user

    get :index
    assert_select '#forums li'
  end

  test 'anonymous user should be redirected' do
    get :index
    assert_redirected_to new_user_session_path
  end
end
