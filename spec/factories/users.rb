# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  nickname               :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
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
