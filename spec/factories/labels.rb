require "faker"

FactoryBot.define do
  factory :label do
    name { Faker::Alphanumeric.alphanumeric(rand(1..Label::NAME_SIZE_MAX)) }
    user
  end
end
