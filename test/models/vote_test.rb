require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  test 'should not save without user' do
    vote = FactoryGirl.build(:vote, user: nil)
    vote.save()

    assert_nil vote.id
  end

  test 'should not save without votable id' do
    user = create_ready_user(login=false)
    vote = FactoryGirl.build(:vote, votable: nil)
    vote.save()

    assert_nil vote.id
  end

  test 'should not save without value' do
    user = create_user_with_post(login=false)
    vote = FactoryGirl.build(:vote, value: nil)
    vote.save()

    assert_nil vote.id
  end

  test 'should not save without votable type' do
    user = create_user_with_post(login=false)
    vote = FactoryGirl.build(:vote, votable_type: nil)
    vote.save()

    assert_nil vote.id
  end

  test 'should not save duplicate votes' do
    user = create_user_with_post(login=false)
    vote1 = FactoryGirl.create(:vote)

    vote1.save()
    assert vote1.id
    
    vote2 = FactoryGirl.build(:vote)
    vote2.save()

    assert_nil vote2.id
  end

  test 'should get user' do
    user = create_user_with_post(login=false)
    vote = FactoryGirl.create(:vote, user: user)

    assert_equal user, vote.user
  end

  test 'should get post' do
    user = create_user_with_post(login=false)
    post = Post.first()
    vote = FactoryGirl.create(:vote, user: user, votable: post)

    assert_equal post, vote.votable
  end
end
