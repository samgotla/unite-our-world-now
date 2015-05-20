Faker::Config.locale = 'en-US'

FactoryGirl.define do
  factory :forum do
    name "MyString"
  end

  factory :user do
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber::cell_phone }
    password 'password'
    sms_code '123456'
  end
end
