FactoryBot.define do
  factory :enrollment do
    association :student, factory: :user
    association :batch, factory: :batch

    student_id { Faker::Number.number(digits: 2) }
    batch_id { Faker::Number.number(digits: 2) }
    school_id { Faker::Number.number(digits: 2) }
    status { 0 }
  end
end
