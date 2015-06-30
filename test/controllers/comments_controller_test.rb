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
    assert_redirected_to forum_post_path(forum, user_post)
  end
end
