FactoryBot.define do
  factory :task do
    name { %w[テストを書く テストを動かす].sample }
    description { %w[RSpec & Capybara & FactoryBot を準備する ''].sample }
  end
end
