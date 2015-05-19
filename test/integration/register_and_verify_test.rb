require 'test_helper'

class RegisterAndVerifyTest < ActionDispatch::IntegrationTest
  def login(user)
    post_via_redirect new_user_session_path, {
                        user: {
                          email: user.email,
                          password: 'password'
                        }
                      }
    assert_equal root_path, path
  end

  def resend_code(user)
    post_via_redirect resend_code_path
    assert_equal edit_user_registration_path, path
  end

  def verify_code(user)
    post_via_redirect verify_code_path, {
                        user: {
                          sms_code: user.sms_code
                        }
                      }
    assert_equal dashboard_path, path

    user = User.find_by_email(user.email)

    assert user.sms_confirmed
  end

  test 'create and verify user' do
    user = FactoryGirl.build(:user)

    open_session do
      post_via_redirect user_registration_path, {
                          user: {
                            email: user.email,
                            phone: user.phone,
                            password: 'password',
                            password_confirm: 'password'
                          }
                        }

      assert_equal edit_user_registration_path, path

      user = User.find_by_email(user.email)
      verify_code(user)
    end
  end

  test 'resend code and verify' do
    user = FactoryGirl.create(:user)

    open_session do
      login(user)
      resend_code(user)

      updated_user = User.find_by_email(user.email)
      assert_not_equal user.sms_code, updated_user.sms_code
    end
  end
end
