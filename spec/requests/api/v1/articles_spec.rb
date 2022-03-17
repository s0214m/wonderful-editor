require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  # index
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    before { create_list(:article, user_count) }

    let(:user_count) { 3 }
    it "全てのarticleが取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.count).to eq user_count
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user", "article_likes", "comments"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      expect(response).to have_http_status(:ok)
    end
  end

  # show
  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    let(:article_id) { article.id }
    let(:article) { create(:article) }
    context "適切なidを指定した時" do
      fit "その記事を取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"]["name"]).to eq article.user.name
        expect(res["user"]["email"]).to eq article.user.email
        expect(response).to have_http_status(:ok)
      end
    end

    context "不適切なidを指定した時" do
      let(:article_id) { 1_000_000 }
      it "エラーになる" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
