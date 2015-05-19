FactoryGirl.define do
  factory :forum do
    name "MyString"
  end

  factory :user do
    email { Faker::Internet.email }
    phone TWILIO_MAGIC_VALID_NUMBER
    password 'password'
  end
end
