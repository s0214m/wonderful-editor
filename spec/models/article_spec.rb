# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_status   (status)
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require "rails_helper"

RSpec.describe Article, type: :model do
  context "title,body,statusを指定している時" do
    let(:article) { build(:article) }
    it "articleが作成される" do
      expect(article).to be_valid
    end
  end

  context "titleを指定していない場合" do
    let(:article) { build(:article, title: nil) }
    it "articleが作られない" do
      expect(article).to be_invalid
      res = article.errors.details[:title][0][:error]
      expect(res).to eq :blank
    end
  end

  context "bodyを指定していない場合" do
    let(:article) { build(:article, body: nil) }
    it "articleが作られない" do
      expect(article).to be_invalid
      res = article.errors.details[:body][0][:error]
      expect(res).to eq :blank
    end
  end

  context "statusを指定していない場合" do
    let(:article) { build(:article, status: nil) }
    it "articleが作られない" do
      expect(article).to be_invalid
      res = article.errors.details[:status][0][:error]
      expect(res).to eq :blank
    end
  end

  context "userを指定していない場合" do
    let(:article) { build(:article, user: nil) }
    it "articleが作られない" do
      expect(article).to be_invalid
      res = article.errors.details[:user][0][:error]
      expect(res).to eq :blank
    end
  end
end
