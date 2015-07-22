require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'verified user should be able to comment' do
    user = create_user_with_post
    user_post = user.posts.first
    forum = Forum.first

    post :create, comment: {
           body: 'body'
         },
         forum_id: forum.id,
         post_id: user_post.id

    comment = Comment.first

    assert_equal user_post.comments.length, 1
    assert_equal comment.user, user
    assert_redirected_to post_path(user_post)
  end

  test 'verified user should be able to vote on a comment' do
    user = create_user_with_comment
    comment = Comment.first

    put :vote, post_id: comment.post.id, comment_id: comment.id, value: 'up'
    assert_equal comment.score, 1
  end

  test 'anonymous user should not be able to vote on a comment' do
    user1 = create_user_with_comment(login=false)
    comment = Comment.first

    put :vote, post_id: comment.post.id, comment_id: comment.id, value: 'up'
    
    assert_redirected_to new_user_session_path
    assert_equal comment.score, 0
  end

  test 'user should be able to delete owned comment' do
    user = create_user_with_comment
    comment = Comment.first

    delete :destroy, id: comment.id
    
    assert_raises ActiveRecord::RecordNotFound do
      Comment.find(comment.id)
    end

    assert_redirected_to post_path(comment.post)
  end

  test 'user should not be able to delete unowned comment' do
    user1 = create_user_with_comment(login=false)
    user2 = create_ready_user
    comment = Comment.first

    assert_raises CanCan::AccessDenied do
      delete :destroy, id: comment.id
    end
  end

  test 'admin should be able to delete any comment' do
    user1 = create_user_with_comment(login=false)
    admin = FactoryGirl.create(:user, role: 'admin')
    comment = Comment.first
    sign_in admin

    delete :destroy, id: comment.id

    assert_equal Comment.all.length, 0
  end

  test 'votes should also be deleted' do
    user1 = create_user_with_comment_vote
    comment = Comment.first

    delete :destroy, id: comment.id

    assert_equal Comment.all.length, 0
    assert_equal Vote.all.length, 0
  end
end
