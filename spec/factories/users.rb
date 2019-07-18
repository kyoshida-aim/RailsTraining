require "faker"

FactoryBot.define do
  factory :user do
    login_id { Faker::Internet.unique.username(4, []) }
    password { Faker::Internet.password }
  end
end
