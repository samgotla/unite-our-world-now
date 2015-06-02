require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @controller = Users::RegistrationsController.new()
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'should delete user' do
    user = FactoryGirl.create(:user)

    sign_in user

    assert_difference('User.count', -1) do
      delete :destroy, id: user.id
    end
  end
  
  test 'should create user' do
    user = FactoryGirl.build(:user)

    post :create, {
           user: {
             phone: user.phone,
             email: user.email,
             password: 'password',
             password_confirm: 'password'
           }
         }

    user = User.find_by_email(user.email)
    assert_not_nil user.id
  end

  test 'should show signup form' do
    get :new
    assert_select 'form.new_user'
  end

  test 'should show edit form' do
    user = FactoryGirl.create(:user)

    sign_in user

    resp = get :edit
    assert_select 'form.edit_user'
  end

  test 'should not show verify buttons for confirmed user' do
    user = FactoryGirl.create(:user, sms_confirmed: true)

    sign_in user

    get :edit
    assert_select 'user_sms_code', false
  end

  test 'should update user attributes' do
    user = FactoryGirl.create(:user)

    sign_in user

    put :update, {
           user: {
             email: user.email + 'xyz'
           }
         }

    updated_user = User.find_by_email(user.email + 'xyz')
    assert_not_nil updated_user
  end

  test 'should not be authorized to resend if not logged in' do
    post :resend_code
    assert_redirected_to new_user_session_path
  end

  test 'should update lat and lng' do
    user = FactoryGirl.create(:user)
    sign_in user    

    put :update, {
          user: {
            latitude: -10,
            longitude: 20
          }
        }

    updated_user = User.find_by_email(user.email)
    assert_equal updated_user.latitude, -10
    assert_equal updated_user.longitude, 20
  end
end
