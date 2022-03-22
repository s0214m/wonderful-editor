require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  # index
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let!(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }
    context "articleが公開ようで自分のarticleの場合" do
      before { create_list(:article, article_count, status: "published", user_id: current_user.id) }

      let(:article_count) { 3 }
      it "公開用のarticleが全て取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.count).to eq article_count
        expect(res[0].keys).to eq ["id", "title", "status", "updated_at", "user", "article_likes", "comments"]
        expect(res[0]["status"]).to eq "published"
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
        expect(res[0]["user"]["id"]).to eq current_user.id
        expect(res[0]["user"]["name"]).to eq current_user.name
        expect(res[0]["user"]["email"]).to eq current_user.email
        expect(response).to have_http_status(:ok)
      end
    end

    context "articleが公開用で他人のarticleの場合" do
      before { create_list(:article, article_count, status: "published", user_id: other_user.id) }

      let(:article_count) { 3 }
      let(:other_user) { create(:user) }
      it "公開用のarticleが取得できない" do
        subject
        res = JSON.parse(response.body)
        expect(res.count).to eq 0
        expect(response).to have_http_status(:ok)
      end
    end

    context "articleが下書き用の場合" do
      before { create_list(:article, article_count, status: "draft", user_id: current_user.id) }

      let(:article_count) { 3 }
      it "articleが取得できない" do
        subject
        res = JSON.parse(response.body)
        expect(res.count).to eq 0
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
