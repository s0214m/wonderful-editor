FactoryBot.define do
  factory :user do
    name { Faker::JapaneseMedia::DragonBall.character }
    sequence(:email) {|n| "#{n}_#{Faker::Internet.email}" }
    sequence(:password) {|n| "#{n}_#{Faker::Internet.password}" }

    trait :with_article do
      after(:create) do |user|
        create_list(:article, 3, user: user)
      end
    end

    trait :with_comment do
      after(:create) do |user|
        create_list(:comment, 3, user: user)
      end
    end

    trait :with_article_like do
      after(:create) do |user|
        create_list(:article_like, 3, user: user)
      end
    end
  end
end
