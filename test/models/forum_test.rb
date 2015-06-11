require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  def setup
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.add_stub(
      "12345", [
        {
          'latitude'     => 40.7143528,
          'longitude'    => -74.0059731,
          'city'         => 'New York',
          'address'      => 'New York, NY, USA',
          'state'        => 'New York',
          'state_code'   => 'NY',
          'country'      => 'United States',
          'country_code' => 'US',
          'zip'          => '12345',
          'address_components' => {
            'county'       => 'county name'
          }
        }
      ]
    )

    Geocoder::Lookup::Test.set_default_stub([])
  end

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
end
