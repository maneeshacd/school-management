FactoryBot.define do
  factory :school do
    id { Faker::Number.unique.number(digits: 4) }
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
  end
end
