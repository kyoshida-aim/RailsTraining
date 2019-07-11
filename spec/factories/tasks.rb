require "faker"

FactoryBot.define do
  factory :task do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    user_id { Faker::Number.number(10) }
  end
end
