require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'should not save without a subject' do
    p = FactoryGirl.build(:post, subject: '')
    p.save
    assert_nil p.id
  end

  test 'should not save without a body' do
    p = FactoryGirl.build(:post, body: nil)
    p.save
    assert_nil p.id
  end

  test 'should not save without a user id' do
    p = FactoryGirl.build(:post, user_id: nil)
    p.save
    assert_nil p.id
  end

  test 'should not save without a forum id' do
    p = FactoryGirl.build(:post, forum_id: nil)
    p.save
    assert_nil p.id
  end
end
