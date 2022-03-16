# Table name: article_likes
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
# Indexex
#  index_article_likes_on_article_id  (article_id)
#  index_article_likes_on_user_id     (user_id)
# Foreign Keys
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)

require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  context "userとarticleが存在する場合" do
    let(:article_like) { build(:article_like) }
    it "いいねが付く" do
      expect(article_like).to be_valid
    end
  end

  context "userが存在しない場合" do
    let(:article_like) { build(:article_like, user: nil) }
    it "いいねがつかない" do
      expect(article_like).to be_invalid
      res = article_like.errors.details[:user][0][:error]
      expect(res).to eq :blank
    end
  end

  context "articleが存在しない場合" do
    let(:article_like) { build(:article_like, article: nil) }
    it "いいねが付かない" do
      expect(article_like).to be_invalid
      res = article_like.errors.details[:article][0][:error]
      expect(res).to eq :blank
    end
  end
end
