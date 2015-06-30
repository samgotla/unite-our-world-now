require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'should not save without a body' do
    c = FactoryGirl.build(:comment, body: '')
    c.save
    assert_nil c.id
  end
end
