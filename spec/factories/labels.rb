require "faker"

FactoryBot.define do
  factory :label do
    name { Faker::Alphanumeric.alphanumeric(rand(1..16)) }
    user
  end
end
