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
      it "その記事を取得できる" do
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

  # create
  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let!(:headers) { current_user.create_new_auth_token }
    context "適切なparamsを送信した場合" do
      context "公開用として" do
        let(:params) { { article: attributes_for(:article).merge(status: "published") } }
        let(:current_user) { create(:user) }
        it "articleが作成される" do
          expect { subject }.to change { current_user.articles.count }.by(1)
          res = JSON.parse(response.body)
          expect(res["status"]).to eq params[:article][:status]
          expect(res["title"]).to eq params[:article][:title]
          expect(res["body"]).to eq params[:article][:body]
          expect(res["updated_at"]).to be_present
          expect(res["user"]["id"]).to eq current_user.id
          expect(res["user"]["name"]).to eq current_user.name
          expect(res["user"]["email"]).to eq current_user.email
          expect(response).to have_http_status(:ok)
        end
      end

      context "下書き用として" do
        let(:params) { { article: attributes_for(:article).merge(status: "unpublished") } }
        let(:current_user) { create(:user) }
        it "articleが作成される" do
          expect { subject }.to change { current_user.articles.count }.by(1)
          res = JSON.parse(response.body)
          expect(res["status"]).to eq params[:article][:status]
          expect(res["title"]).to eq params[:article][:title]
          expect(res["body"]).to eq params[:article][:body]
          expect(res["updated_at"]).to be_present
          expect(res["user"]["id"]).to eq current_user.id
          expect(res["user"]["name"]).to eq current_user.name
          expect(res["user"]["email"]).to eq current_user.email
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "不適切なparamsを送信した場合" do
      let(:params) { attributes_for(:article) }
      let(:current_user) { create(:user) }
      it "エラーが出る" do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  # update
  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article_id), params: params, headers: headers) }

    let(:article_id) { article.id }
    let(:current_user) { create(:user) }
    let!(:headers) { current_user.create_new_auth_token }
    context "自身の記事を更新しようとした時" do
      let!(:article) { create(:article, user: current_user) }
      let(:params) { { article: { title: Faker::Movie.title, user: create(:user) } } }
      it "更新できる" do
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title])
        not_change { article.reload.user }
      end
    end

    context "他人の投稿を更新しようとした時" do
      let!(:article) { create(:article, user: other_user) }
      let(:other_user) { create(:user) }
      let(:params) { { article: { title: Faker::Movie.title } } }
      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  # destroy
  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }

    let(:article_id) { article.id }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自身の記事を削除しようとした時" do
      let!(:article) { create(:article, user: current_user) }
      it "削除できる" do
        expect { subject }.to change { current_user.articles.count }.by(-1)
      end
    end

    context "他人の投稿を削除しようとした時" do
      let!(:article) { create(:article, user: other_user) }
      let(:other_user) { create(:user) }

      it "削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end
end
