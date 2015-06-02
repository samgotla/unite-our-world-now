FactoryGirl.define do
  factory :forum do
    name "MyString"
  end

  factory :user do
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber::cell_phone }
    password 'password'
    sms_code '123456'
    latitude 12.3456
    longitude 12.3456
  end
end
