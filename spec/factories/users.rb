FactoryBot.define do
  factory :user do
    name { Faker::JapaneseMedia::DragonBall.character }
    sequence(:email) {|n| "#{n}_#{Faker::Internet.email}" }
    sequence(:password) {|n| "#{n}_#{Faker::Internet.password}" }
  end
end
