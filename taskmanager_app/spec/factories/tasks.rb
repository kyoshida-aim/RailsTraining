require "faker"

FactoryBot.define do
  factory :task do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
  end
end
