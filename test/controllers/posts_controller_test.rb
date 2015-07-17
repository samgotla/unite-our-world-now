require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'verified user should be able to create a post' do
    user = create_ready_user
    forum = Forum.first

    post :create, post: {
           subject: 'subject',
           body: 'body'
         }, forum_id: forum.id

    first_post = Post.first

    assert_equal forum.posts.length, 1
    assert_equal first_post.user, user
    assert_redirected_to forum_post_path(forum, first_post)
  end

  test 'unverified user should not be able to create a post' do
    user = FactoryGirl.create(:user)
    forum = FactoryGirl.create(:forum)

    sign_in user

    post :create, post: {
           subject: 'subject',
           body: 'body'
         }, forum_id: forum.id

    assert_equal forum.posts.length, 0
  end

  test 'should see comments' do
    user = create_user_with_comment
    comment = user.comments.first

    get :show, forum_id: Forum.first.id, id: user.posts.first.id

    assert_select '#comments .comment', 1
  end

  test 'verified user should be able to upvote post' do
    user = create_user_with_post
    post1 = Post.first

    post :upvote, forum_id: post1.forum.id, post_id: post1.id

    assert_equal post1.score, 1
  end

  test 'verified user should be able to downvote post' do
    user = create_user_with_post
    post1 = Post.first

    post :downvote, forum_id: post1.forum.id, post_id: post1.id

    assert_equal post1.score, -1
  end

  test 'unverified user should not be able to vote on post' do
    user = create_user_with_post
    user.update(sms_confirmed: false)
    post1 = Post.first

    post :upvote, forum_id: post1.forum.id, post_id: post1.id

    assert_equal post1.score, 0
  end

  test 'anonymous user should not be able to vote on post' do
    user = create_user_with_post(login=false)
    post1 = Post.first

    post :upvote, forum_id: post1.forum.id, post_id: post1.id

    assert_equal post1.score, 0
  end

  test 'should see arrow marked as voted on post page' do
    user = create_user_with_post_vote
    post1 = Post.first

    get :show, forum_id: post1.forum.id, id: post1.id

    assert_select 'a.vote.voted'
  end
end
