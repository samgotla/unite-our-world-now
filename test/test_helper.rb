ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'database_cleaner'
require 'capybara/rails'

def setup_geocoder
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

class ActiveSupport::TestCase
  def setup
    setup_geocoder
  end

  def create_ready_user(login=true)
    user = FactoryGirl.create(:user, sms_confirmed: true)
    Forum.generate(user, :zip)

    if login
      sign_in user
    end

    return user
  end

  def create_user_with_post(*args)
    user = create_ready_user(*args)
    forum = Forum.first
    post = FactoryGirl.create(:post, user: user, forum: forum)

    return user
  end

  def create_user_with_approved_post(*args)
    user = create_ready_user(*args)
    forum = Forum.first
    post = FactoryGirl.create(:post, user: user, forum: forum, approved: true)

    return user
  end

  def create_user_with_comment(*args)
    user = create_user_with_post(*args)
    post = Post.first
    comment = FactoryGirl.create(:comment, user: user, post: post)

    return user
  end

  def create_user_with_post_vote(*args)
    user = create_user_with_post(*args)
    post = Post.first
    vote = FactoryGirl.create(:vote, user: user, votable: post)

    return user
  end

  def create_user_with_comment_vote(*args)
    user = create_user_with_comment(*args)
    comment = Comment.first
    vote = FactoryGirl.create(:vote, user: user, votable: comment)

    return user
  end

  def login(user)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  Capybara.app_host = 'http://localhost:3001'
  Capybara.current_driver = :selenium
  Capybara.server_port = 3001
  Capybara.run_server = true
  
  DatabaseCleaner.strategy = :truncation

  self.use_transactional_fixtures = false

  def setup
    setup_geocoder
  end

  def teardown
    DatabaseCleaner.clean
  end
end
