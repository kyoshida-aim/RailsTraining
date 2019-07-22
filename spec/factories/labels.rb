require "faker"

FactoryBot.define do
  factory :label do
    name { Faker::Name.name }
    user
  end
end
