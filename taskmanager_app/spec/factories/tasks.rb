require 'faker'

FactoryBot.define do
  factory :task do
    name { [Faker::Name.name, Faker::Name.name].sample }
    description { [Faker::String.random(10)].sample }
  end
end
