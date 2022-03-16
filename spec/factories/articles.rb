# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :article do
    title { Faker::Movie.title }
    body { Faker::Lorem.paragraph }
    user

    trait :with_comment do
      after(:create) do |article|
        create_list(:comment, 3, article: article)
      end
    end

    trait :with_article_like do
      after(:create) do |article|
        create_list(:article_like, 3, article: article)
      end
    end
  end
end
