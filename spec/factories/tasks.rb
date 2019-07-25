require "faker"

FactoryBot.define do
  factory :task do
    name { Faker::Alphanumeric.alphanumeric(1..30) }
    description { Faker::Lorem.paragraph }
    user
  end
end
