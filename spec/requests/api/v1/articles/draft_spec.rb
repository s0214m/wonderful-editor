require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  # index
  describe "GET /api/v1/articles/draft" do
    subject { get(api_v1_articles_draft_index_path, headers: headers) }

    let!(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }
    context "articleが下書きで自分のarticleの場合" do
      before { create_list(:article, article_count, status: "draft", user_id: current_user.id) }

      let(:article_count) { 3 }
      it "下書きのarticleが全て取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.count).to eq article_count
        expect(res[0].keys).to eq ["id", "title", "status", "updated_at", "user", "article_likes", "comments"]
        expect(res[0]["status"]).to eq "draft"
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
        expect(res[0]["user"]["id"]).to eq current_user.id
        expect(res[0]["user"]["name"]).to eq current_user.name
        expect(res[0]["user"]["email"]).to eq current_user.email
        expect(response).to have_http_status(:ok)
      end
    end

    context "articleが下書きで他人のarticleの場合" do
      before { create_list(:article, article_count, status: "draft", user_id: other_user.id) }

      let(:article_count) { 3 }
      let(:other_user) { create(:user) }
      it "下書きのarticleが取得できない" do
        subject
        res = JSON.parse(response.body)
        expect(res.count).to eq 0
        expect(response).to have_http_status(:ok)
      end
    end

    context "articleが公開用の場合" do
      before { create_list(:article, article_count, status: "published", user_id: current_user.id) }

      let(:article_count) { 3 }
      it "articleが取得できない" do
        subject
        res = JSON.parse(response.body)
        expect(res.count).to eq 0
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # show
  describe "GET /api/v1/articles/draft/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    let!(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }
    context "適切なidを指定していて自身のarticleが下書き用の場合" do
      let(:article) { create(:article, status: "draft", user_id: current_user.id) }
      let(:article_id) { article.id }
      it "そのarticleを取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["status"]).to eq "draft"
        expect(res["user"]["id"]).to eq current_user.id
        expect(res["user"]["name"]).to eq current_user.name
        expect(res["user"]["email"]).to eq current_user.email
        expect(response).to have_http_status(:ok)
      end
    end

    context "適切なidを指定していて自身のarticleが公開用の場合" do
      let(:article) { create(:article, status: "published", user_id: current_user.id) }
      let(:article_id) { article.id }
      it "そのarticleを取得できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "適切なidを指定していて下書き用だが、他人のarticleの場合" do
      let(:article) { create(:article, status: "draft", user_id: other_user.id) }
      let(:other_user) { create(:user) }
      let(:article_id) { article.id }
      it "そのarticleを取得できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "不適切なidを指定した時" do
      let(:article) { create(:article, status: "draft") }
      let(:article_id) { 10000 }
      it "エラーになる" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
