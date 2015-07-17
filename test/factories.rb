FactoryGirl.define do
  factory :vote do
    user_id 1
    votable_id 1
    value 1
    votable_type 'Post'
  end

  factory :user do
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber::cell_phone }
    password 'password'
    sms_code '123456'
    latitude 12.3456
    longitude 12.3456
    zip_code '12345'
  end

  factory :post do
    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.sentence }
    forum_id 999
    user_id 999
  end

  factory :forum do
    name { Faker::Address.state }
  end

  factory :comment do
    body { Faker::Lorem.sentence }
    post_id 999
    user_id 999
  end
end
