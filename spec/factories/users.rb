require "faker"

FactoryBot.define do
  factory :user do
    login_id { Faker::Internet.unique.username }
    password { Faker::Internet.password }
  end
end
