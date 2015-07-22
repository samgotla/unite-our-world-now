require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'should not save without a body' do
    c = FactoryGirl.build(:comment, body: '')
    c.save
    assert_nil c.id
  end

  test 'should get user' do
    user = create_user_with_comment(login=false)
    c = Comment.first
    assert c.user, user
  end

  test 'should get votes' do
    user = create_user_with_comment_vote(login=false)
    c = Comment.first
    assert_equal c.votes.length, 1
  end

  test 'should calculate score' do
    user = create_user_with_comment_vote(login=false)
    c = Comment.first
    assert_equal c.score, 1
  end

  test 'should return proper vote class' do
    user = create_user_with_comment_vote(login=false)
    c = Comment.first
    assert_equal c.vote_class(user, :up), 'voted'
  end
end
