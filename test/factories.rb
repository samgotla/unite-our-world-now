TWILIO_MAGIC_VALID_NUMBER = '5005550006'
TWILIO_MAGIC_INVALID_NUMBER = '5005550001'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    phone TWILIO_MAGIC_VALID_NUMBER
    password 'password'
  end
end
