require "faker"

FactoryBot.define do
  factory :label do
    name { Faker::Alphanumeric.alphanumeric(rand(1..Label::NAME_LENGTH_MAX)) }
    user
  end
end
