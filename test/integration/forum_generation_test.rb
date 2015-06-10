require 'test_helper'

class ForumGenerationTest < ActionDispatch::IntegrationTest
  def login(user)
    post_via_redirect new_user_session_path, {
                        user: {
                          email: user.email,
                          password: 'password'
                        }
                      }
    assert_equal dashboard_path, path
  end

  test 'display forum list after generation' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user)

    open_session do
      login(user)

      put_via_redirect user_registration_path, {
                         user: {
                           zip_code: '12300'
                         }
                       }

      assert_equal dashboard_path, path

      get forums_path
      assert_select '#forums li', 5
    end
  end
end
