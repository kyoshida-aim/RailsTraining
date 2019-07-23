require "faker"

FactoryBot.define do
  factory :label do
    name { Faker::String.random(1..16) }
    user
  end
end
