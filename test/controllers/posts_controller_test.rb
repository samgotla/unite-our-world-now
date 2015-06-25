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
    assert_redirected_to forum_path(forum)
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
end
