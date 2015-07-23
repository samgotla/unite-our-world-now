require 'test_helper'

class ForumsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'logged in user should see their forums' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user, :zip)
    sign_in user

    get :index
    assert_select '#forums li', 5
  end

  test 'anonymous user should be redirected' do
    get :index
    assert_redirected_to new_user_session_path
  end

  test 'unconfirmed user should be redirected' do
    user = FactoryGirl.create(:user)
    sign_in user
    get :index
    assert_redirected_to edit_user_registration_path
  end

  test 'logged in user should see forum title' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user, :zip)
    sign_in user

    get :show, id: user.forum_id
    assert_select 'h3', user.forum.name
  end

  test 'should show children' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user, :zip)
    sign_in user

    get :children, id: user.forum.parent.id
    assert_select '#forums li', 1
  end

  test 'should redirect if no forums exist' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    sign_in user

    get :index
    assert_redirected_to edit_user_registration_path
  end

  test 'should show search results' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user, :zip)
    sign_in user

    get :search, term: 'new'
    assert_select '#forums li', 3
  end

  test 'should redirect if term is too short' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user, :zip)
    sign_in user

    get :search, term: 'x'
    assert_redirected_to forums_path
  end

  test 'should show no results if none are found' do
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user, :zip)
    sign_in user

    get :search, term: 'abcdef'
    assert_select '#forums li', 0
  end

  test 'should see all forum posts' do
    user = create_user_with_post
    forum = Forum.first

    get :all_posts, id: forum.id

    assert_select '#posts .post', 1
  end

  test 'should see approved posts' do
    user = create_user_with_approved_post
    forum = Forum.first

    get :show, id: forum.id

    assert_select '#posts .post', 1
  end

  test 'should see arrow marked as voted on forum page' do
    user = create_user_with_post_vote
    post1 = Post.first

    get :all_posts, id: post1.forum.id

    assert_select 'a.vote.voted'
  end

  test 'moderator should see approve button on forum page' do
    user = create_user_with_post
    user.update(role: 'moderator')
    post1 = Post.first

    get :all_posts, id: post1.forum.id

    assert_select 'a.moderate', 1
  end

  test 'poster should not see approve button on forum page' do
    user = create_user_with_post
    post1 = Post.first

    get :all_posts, id: post1.forum.id

    assert_select 'a.moderate', 0
  end

  test 'should not see unapproved post on main forum page' do
    user = create_user_with_post
    post1 = Post.first

    get :show, id: post1.forum.id

    assert_select '.post', 0
  end

  test 'should see unapproved post on all posts page' do
    user = create_user_with_post
    post1 = Post.first

    get :all_posts, id: post1.forum.id

    assert_select '.post', 1
  end

  test 'should not see deleted user email in post header' do
    user1 = create_user_with_post(login=false)
    user2 = create_ready_user

    user1.destroy
    get :all_posts, id: Forum.first.id

    assert_select '.post-date', /deleted/
  end
end
