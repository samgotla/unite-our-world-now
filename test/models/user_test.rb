require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should not save user without email' do
    user = FactoryGirl.build(:user, email: nil)
    assert_not user.save
  end

  test 'should not save user without phone' do
    user = FactoryGirl.build(:user, phone: nil)
    assert_not user.save
  end

  test 'should not save invalid phone' do
    user = FactoryGirl.build(:user, phone: '1234')
    assert_not user.save
  end

  test 'should not save user without password' do
    user = FactoryGirl.build(:user, password: nil)
    assert_not user.save
  end

  test 'should save valid user' do
    user = FactoryGirl.build(:user)
    assert user.save    
  end

  test 'should have an SMS code' do
    user = FactoryGirl.create(:user)
    assert_equal(User.sms_code_length, user.sms_code.length)
  end
end
