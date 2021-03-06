require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  test 'should not save without a name' do
    f = Forum.new()
    f.save()
    assert_nil f.id
  end

  test 'should generate forums with a valid zip' do
    user = FactoryGirl.create(:user)
    Forum.generate(user, :zip)

    assert_equal Forum.count, 5
  end

  test 'should not generate forums without a valid zip' do
    user = FactoryGirl.create(:user, zip_code: '00000')
    Forum.generate(user, :zip)

    assert_equal Forum.count, 0
  end

  test 'should assign parents to forums' do
    user = FactoryGirl.create(:user)
    Forum.generate(user, :zip)

    Forum.all.each do |f|
      if f.name != 'World'
        assert_not_nil f.parent_id
      end
    end
  end

  test 'should generate forums with full state name' do
    user = FactoryGirl.create(:user)
    Forum.generate(user, :zip)

    assert_match 'New York', user.forum.name
  end

  test 'should get children' do
    user = FactoryGirl.create(:user)
    Forum.generate(user, :zip)

    assert_not_empty user.forum.parent.children
  end

  test 'should get all posts' do
    forum = FactoryGirl.create(:forum)
    post = FactoryGirl.create(:post, forum_id: forum.id)

    assert_equal forum.posts.length, 1
  end

  test 'should get approved posts' do
    forum = FactoryGirl.create(:forum)
    post = FactoryGirl.create(:post, forum_id: forum.id, approved: true)

    assert_equal forum.approved_posts.length, 1
  end

  test 'should get pending posts' do
    forum = FactoryGirl.create(:forum)
    post = FactoryGirl.create(:post, forum_id: forum.id)

    assert_equal forum.pending_posts.length, 1
  end
end
