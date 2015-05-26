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
    user = FactoryGirl.build(:user, phone: 'abcd')
    assert_not user.save
  end

  test 'should not save short phone' do
    user = FactoryGirl.build(:user, phone: '123456')
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
    assert_equal(User::SMS_CODE_LENGTH, user.sms_code.length)
  end

  test 'should generate new code when phone number is changed' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    user.update!(phone: Faker::PhoneNumber::cell_phone)
    assert user.previous_changes[:sms_code]
  end

  test 'should send SMS when created' do
    user = FactoryGirl.build(:user)
    user.sms_code = '123456'
    assert user.send(:should_send_sms?)
  end

  test 'should not be able to post topic if unconfirmed' do
    user = FactoryGirl.create(:user)
    ability = Ability.new(user)

    assert ability.cannot?(:post_topic, nil)
  end
end
