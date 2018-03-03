FactoryBot.define do
  factory :entry do
    comment { Faker::Lorem.sentence(20) }
    user
    prize
  end
end
