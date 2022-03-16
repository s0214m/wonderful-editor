# Table name: articles
#  id         :bigint           not null, primary key
#  body       :text                       presence: true
#  title      :string                     presence: ture
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null  user must be exist
# Indexes
#  index_articles_on_user_id  (user_id)
# Foreign Keys
#  fk_rails_...  (user_id => users.id)

require "rails_helper"

RSpec.describe Article, type: :model do
  context "title,body,を指定している時" do
    it "articleが作成される" do
      article = build(:article)
      expect(article).to be_valid
    end
  end

  context "titleを指定していない場合" do
    it "articleが作られない" do
      article = build(:article, title: nil)
      expect(article).to be_invalid
      res = article.errors.details[:title][0][:error]
      expect(res).to eq :blank
    end
  end

  context "bodyを指定していない場合" do
    it "articleが作られない" do
      article = build(:article, body: nil)
      expect(article).to be_invalid
      res = article.errors.details[:body][0][:error]
      expect(res).to eq :blank
    end
  end

  context "userを指定していない場合" do
    it "articleが作られない" do
      article = build(:article, user: nil)
      expect(article).to be_invalid
      res = article.errors.details[:user][0][:error]
      expect(res).to eq :blank
    end
  end
end
