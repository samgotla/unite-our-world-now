require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @controller = Devise::SessionsController.new()
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'should redirect to dashboard after login' do
    user = FactoryGirl.create(:user)

    post :create, {
           user: {
             email: user.email,
             password: 'password'
           }
         }
    assert_redirected_to dashboard_path
  end
end
