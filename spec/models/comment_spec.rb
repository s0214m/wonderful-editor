# Table name: comments
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
# Indexes
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
# Foreign Keys
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)

require "rails_helper"

RSpec.describe Comment, type: :model do
  context "bodyを指定している時" do
    it "commentが作成される" do
      comment = build(:comment)
      expect(comment).to be_valid
    end
  end

  context "bodyを指定していない場合" do
    it "commentが作られない" do
      comment = build(:comment, body: nil)
      expect(comment).to be_invalid
      res = comment.errors.details[:body][0][:error]
      expect(res).to eq :blank
    end
  end

  context "userがいない場合" do
    it "commentが作られない" do
      comment = build(:comment, user: nil)
      expect(comment).to be_invalid
      res = comment.errors.details[:user][0][:error]
      expect(res).to eq :blank
    end
  end

  context "articleがない場合" do
    it "commentが作られない" do
      comment = build(:comment, article: nil)
      expect(comment).to be_invalid
      res = comment.errors.details[:article][0][:error]
      expect(res).to eq :blank
    end
  end
end
