FactoryBot.define do
  factory :batch do
    association :course, factory: :course
    name { Faker::Name.name }
    start_date { Faker::Date.between(from: '2024-1-1', to: '2024-12-1') }
    end_date { Faker::Date.between(from: '2025-1-1', to: '2025-12-1') }
    description { Faker::Lorem.sentence }
    course_id { Faker::Number.number(digits: 2) }
  end
end
