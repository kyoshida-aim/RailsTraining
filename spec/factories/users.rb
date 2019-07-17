require "faker"

FactoryBot.define do
  factory :user do
    login_id { Faker::Internet.unique.username(nil, []) }
    password { Faker::Internet.password }
  end
end
