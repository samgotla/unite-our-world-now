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
    assert_redirected_to post_path(first_post)
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

    # MiniTest allows wrong verb? (but this fails in the real world)
    put :vote, forum_id: post1.forum.id, post_id: post1.id, value: 'up'

    data = JSON.parse(@response.body)

    assert_equal data['score'], 1
    assert_equal post1.score, 1
  end

  test 'verified user should be able to downvote post' do
    user = create_user_with_post
    post1 = Post.first

    put :vote, forum_id: post1.forum.id, post_id: post1.id, value: 'down'

    data = JSON.parse(@response.body)

    assert_equal data['score'], -1
    assert_equal post1.score, -1
  end

  test 'unverified user should not be able to vote on post' do
    user = create_user_with_post
    user.update(sms_confirmed: false)
    post1 = Post.first

    put :vote, forum_id: post1.forum.id, post_id: post1.id, value: 'up'

    assert_equal post1.score, 0
  end

  test 'anonymous user should not be able to vote on post' do
    user = create_user_with_post(login=false)
    post1 = Post.first

    put :vote, forum_id: post1.forum.id, post_id: post1.id, value: 'up'

    assert_equal post1.score, 0
  end

  test 'should see arrow marked as voted on post page' do
    user = create_user_with_post_vote
    post1 = Post.first

    get :show, forum_id: post1.forum.id, id: post1.id

    assert_select 'a.vote.voted'
  end

  test 'moderator should be able to approve post' do
    user = create_user_with_post
    user.update(role: 'moderator')

    post1 = Post.first

    put :approve, forum_id: post1.forum.id, post_id: post1.id
    data = JSON.parse(@response.body)

    assert data['approved']
  end

  test 'moderator should be able to unapprove post' do
    user = create_user_with_post
    user.update(role: 'moderator')

    post1 = Post.first
    post1.update(approved: true)

    put :approve, forum_id: post1.forum.id, post_id: post1.id
    data = JSON.parse(@response.body)

    assert_not data['approved']
  end

  test 'normal user should not be able to appprove post' do
    user = create_user_with_post
    post1 = Post.first

    assert_raises CanCan::AccessDenied do
      put :approve, forum_id: post1.forum.id, post_id: post1.id
    end
  end

  test 'normal user should not see approve button' do
    user = create_user_with_post
    post1 = Post.first

    get :show, forum_id: post1.forum.id, id: post1.id

    assert_select 'a.moderate', 0
  end

  test 'user should be able to delete owned post' do
    user = create_user_with_post
    post1 = Post.first

    delete :destroy, id: post1.id

    assert_equal Post.all.length, 0
  end

  test 'user should not be able to delete unowned post' do
    user1 = create_user_with_post(login=false)
    user2 = create_ready_user
    post1 = Post.first

    assert_raises CanCan::AccessDenied do
      delete :destroy, id: post1.id
    end
  end

  test 'admin should be able to delete any post' do
    user1 = create_user_with_post(login=false)
    admin = FactoryGirl.create(:user, role: 'admin')
    post1 = Post.first
    sign_in admin

    delete :destroy, id: post1.id

    assert_equal Post.all.length, 0
  end

  test 'owning user should see delete button' do
    user = create_user_with_post

    get :show, id: Post.first.id

    assert_select '.post .delete-post', 1
  end

  test 'other user should not see delete button' do
    user1 = create_user_with_post(login=false)
    user2 = create_ready_user

    get :show, id: Post.first.id

    assert_select '.post .delete-post', 0
  end

  test 'comment owner should see comment delete button' do
    user = create_user_with_comment

    get :show, id: Comment.first.post.id

    assert_select '.comment .delete-comment', 1
  end

  test 'other user should not see comment delete button' do
    user1 = create_user_with_comment(login=false)
    user2 = create_ready_user

    get :show, id: Post.first.id

    assert_select '.comment .delete-comment', 0
  end

  test 'owning user should be able to see edit page' do
    user1 = create_user_with_post

    get :edit, id: Post.first.id

    assert_select 'form.edit_post', 1
  end

  test 'other user should not be able to see edit page' do
    user1 = create_user_with_post(login=false)
    user2 = create_ready_user

    assert_raises CanCan::AccessDenied do
      get :edit, id: Post.first.id
    end
  end

  test 'owning user should be able to update post' do
    user1 = create_user_with_post
    post1 = Post.first

    put :update, post: { body: 'updated' }, id: post1.id
    post1 = Post.first
    
    assert_equal post1.body, 'updated'
  end

  test 'other user should not be able to update post' do
    user1 = create_user_with_post(login=false)
    user2 = create_ready_user

    assert_raises CanCan::AccessDenied do
      put :update, id: Post.first.id
    end
  end

  test 'owning user should see edit button' do
    user1 = create_user_with_post

    get :show, id: Post.first.id

    assert_select '.edit-post', 1
  end

  test 'other user should not see edit button' do
    user1 = create_user_with_post(login=false)
    user2 = create_ready_user

    get :show, id: Post.first.id

    assert_select '.edit-post', 0
  end

  test 'owning user should see comment edit button' do
    user = create_user_with_comment

    get :show, id: Post.first.id

    assert_select 'a.edit-comment'
  end

  test 'other user should not see comment edit button' do
    user1 = create_user_with_post(login=false)
    user2 = create_ready_user

    get :show, id: Post.first.id

    assert_select 'a.edit-comment', 0
  end

  test 'should not see deleted user email in post header' do
    user1 = create_user_with_post(login=false)
    user2 = create_ready_user

    user1.destroy
    get :show, id: Post.first.id

    assert_select '.post-date', /deleted/
  end

  test 'should not see deleted user email in comment header' do
    user1 = create_user_with_comment(login=false)
    user2 = create_ready_user

    user1.destroy
    get :show, id: Post.first.id

    assert_select '.comment .post-date', /deleted/
  end
end
