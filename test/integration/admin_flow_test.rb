require 'test_helper'

class AdminFlowTest < ActionDispatch::IntegrationTest
  test 'user search' do
    user = create_ready_user(login=false)
    admin = create_admin
    login admin

    visit dashboard_path
    click_button 'Search'

    assert has_css? '#users .row'
    assert has_content? admin.email
    assert has_content? user.email
  end

  test 'show pending users' do
    user = FactoryGirl.create(:user)
    admin = create_admin
    login admin

    visit dashboard_path
    assert has_css? '#pending_users li', 1
  end

  test 'delete a user' do
    user = FactoryGirl.create(:user)
    admin = create_admin
    login admin

    visit dashboard_path
    click_button 'Search'
    
    click_link 'delete_user_%d' % user.id
    assert has_content? I18n.t 'labels.deleted'
  end

  test 'restore a user' do
    user = FactoryGirl.create(:user)
    admin = create_admin
    login admin

    visit dashboard_path
    click_button 'Search'
    
    click_link 'delete_user_%d' % user.id
    assert has_content? I18n.t 'labels.deleted'

    click_link 'restore_user_%d' % user.id
    assert_not has_content? I18n.t 'labels.deleted'
  end

  test 'promote a user to mod' do
    user = create_ready_user(login=false)
    admin = create_admin
    login admin

    visit dashboard_path
    click_button 'Search'

    click_link 'promote_user_%d' % user.id
    assert has_content? I18n.t 'labels.moderator'
  end

  test 'demote a user' do
    user = create_ready_user(login=false)
    admin = create_admin
    login admin

    visit dashboard_path
    click_button 'Search'

    click_link 'promote_user_%d' % user.id
    assert has_content? I18n.t 'labels.moderator'

    click_link 'demote_user_%d' % user.id
    assert has_content? I18n.t 'labels.poster'
  end

  test 'verify a user' do
    user = FactoryGirl.create(:user)
    admin = create_admin
    login admin

    visit dashboard_path
    click_button 'Search'

    click_link 'verify_user_%d' % user.id
    assert_not has_content? I18n.t 'labels.unconfirmed'
  end

  test 'approve post' do
    user = create_user_with_post(login=false)
    admin = create_admin
    login admin

    visit post_path Post.first
    click_link 'approve_post_%d' % Post.first.id
    assert has_css? '.post .glyphicon-remove'    
  end

  test 'unapprove post' do
    user = create_user_with_post(login=false)
    admin = create_admin
    Post.first.update(approved: true)
    login admin

    visit post_path Post.first
    click_link 'unapprove_post_%d' % Post.first.id
    assert has_css? '.post .glyphicon-ok' 
  end

  test 'delete a post' do
    user = create_user_with_post(login=false)
    admin = create_admin
    login admin

    visit post_path Post.first
    click_link 'delete_post_%d' % Post.first.id

    assert has_content? I18n.t 'msg.post_deleted'
  end

  test 'delete a comment' do
    user = create_user_with_comment(login=false)
    admin = create_admin
    login admin

    visit post_path Comment.first.post
    click_link 'delete_comment_%d' % Comment.first.post.id

    assert has_content? I18n.t 'msg.comment_deleted'
  end
end
