# spec/factories.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    uid { Faker::Number.number(digits: 10) }
    provider { 'google_oauth2' }
  end

  factory :admin do
    user # Assumes you have a User factory
  end

  factory :faculty do
    association :user # Assumes you have a User factory
    department { Faker::Commerce.department }
  end

  factory :project do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    num_positions { Faker::Number.between(from: 1, to: 5) }
    areas_of_research { Faker::Lorem.sentence }
    start_semester { "Fall #{Date.today.year + 1}" } # Example: "Fall 2025"
  end
end
