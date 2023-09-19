FactoryBot.define do
  factory :user do
    association :school, factory: :school
    id { Faker::Number.number(digits: 4) }
    name { Faker::Name.name }
    email { "#{Faker::Internet.user_name}@customdomain.com" }
    description { Faker::Lorem.sentence }
    school_id { Faker::Number.number(digits: 4) }
    phone_number { Faker::PhoneNumber.phone_number }
    password { 'password' }
    password_confirmation { 'password' }
    role { 0 }
    jti { Faker::Name.name }
  end
end
