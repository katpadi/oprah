FactoryBot.define do
  factory :user do
    name { Faker::RickAndMorty.character }
    email { Faker::Internet.email }
    password { '12345678' }
  end
end
