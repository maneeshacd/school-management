FactoryBot.define do
  factory :api_user do
    association :school, factory: :school
    name { Faker::Name.name }
    email { "#{Faker::Internet.user_name}@customdomain.com" }
    description { Faker::Lorem.sentence }
    school_id { Faker::Number.number(digits: 2) }
    phone_number { Faker::PhoneNumber.phone_number }
    password { 'password' }
    password_confirmation { 'password' }
    role { 0 }
    jti { Faker::Name.name }
  end
end
