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

  test 'should get comments' do
    user = create_user_with_comment(login=false)
    post = Post.first

    assert_equal post.comments.length, 1
  end

  test 'should get votes' do
    user = create_user_with_post_vote(login=false)
    post = Post.first

    assert_equal post.votes.length, 1
  end

  test 'should calculate correct score' do
    user = create_user_with_post_vote(login=false)
    post = Post.first

    assert_equal post.score, 1
  end

  test 'should return correct vote css class' do
    user = create_user_with_post_vote(login=false)
    post = Post.first

    assert_equal post.vote_class(user, :up), 'voted'
  end
end
