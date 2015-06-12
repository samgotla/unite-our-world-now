ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
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
end
