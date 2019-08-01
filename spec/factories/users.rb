require "faker"

FactoryBot.define do
  factory :user do
    login_id { Faker::Internet.unique.username(specifier: 4, separators: []) }
    password { Faker::Internet.password }
  end
end
