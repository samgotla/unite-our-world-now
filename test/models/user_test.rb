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

  test 'should not be able to post topic if unconfirmed' do
    user = FactoryGirl.create(:user)
    ability = Ability.new(user)

    assert ability.cannot?(:post_topic, nil)
  end

  test 'should not save invalid lat or lng' do
    user = FactoryGirl.build(:user, latitude: 'x', longitude: 'y')
    assert_not user.save
  end

  test 'should return loc as json' do
    user = FactoryGirl.create(:user)
    loc = JSON.parse(user.loc_json())
    assert_equal user.latitude, loc['lat']
    assert_equal user.longitude, loc['lng']
  end

  test 'should update forum id when zip is changed' do
    user = FactoryGirl.create(:user)
    Forum.generate(user, :zip)

    assert_not_nil user.forum_id
  end
end
