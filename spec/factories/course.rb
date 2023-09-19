FactoryBot.define do
  factory :course do
    association :school, factory: :school
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    years { Faker::Number.number(digits: 4) }
    school_id { Faker::Number.number(digits: 2) }
  end
end
