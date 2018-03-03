FactoryBot.define do
  factory :prize do
    name { Faker::Lorem.sentence(2) }
    description { Faker::Lorem.sentence(3) }
    user
  end
end
