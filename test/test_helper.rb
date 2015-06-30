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

  def create_ready_user
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user, :zip)
    sign_in user

    return user
  end

  def create_user_with_post
    user = create_ready_user
    forum = Forum.first
    post = FactoryGirl.create(:post, user: user, forum: forum)

    return user
  end

  def create_user_with_comment
    user = create_user_with_post
    post = Post.first
    comment = FactoryGirl.create(:comment, user: user, post: post)

    return user
  end
end
