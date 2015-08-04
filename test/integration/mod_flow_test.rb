require 'test_helper'

class ModFlowTest < ActionDispatch::IntegrationTest
  test 'approve post' do
    user = create_user_with_post(login=false)
    mod = create_ready_user(login=false)
    mod.update(role: 'moderator')
    login mod

    visit post_path Post.first
    click_link 'approve_post_%d' % Post.first.id
    assert has_css? '.post .glyphicon-remove'    
  end

  test 'unapprove post' do
    user = create_user_with_post(login=false)
    mod = create_ready_user(login=false)
    mod.update(role: 'moderator')
    Post.first.update(approved: true)
    login mod

    visit post_path Post.first
    click_link 'unapprove_post_%d' % Post.first.id
    assert has_css? '.post .glyphicon-ok' 
  end
end
