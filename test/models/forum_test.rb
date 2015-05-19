require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  test 'should not save without a name' do
    f = Forum.new()
    f.save()
    assert_nil f.id
  end
end
