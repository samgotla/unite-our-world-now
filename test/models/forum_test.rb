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
    Forum.generate(user)

    assert_equal Forum.count, 5
  end

  test 'should not generate forums without a valid zip' do
    user = FactoryGirl.create(:user, zip_code: '00000')
    Forum.generate(user)

    assert_equal Forum.count, 0
  end

  test 'should assign parents to forums' do
    user = FactoryGirl.create(:user)
    Forum.generate(user)

    Forum.all.each do |f|
      if f.name != 'World'
        assert_not_nil f.parent_id
      end
    end
  end
end
