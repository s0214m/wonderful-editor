require 'rails_helper'

RSpec.describe "Api::V1::Articles", type: :request do
  #index
  describe "GET /api/v1/articles" do
    subject{get(api_v1_articles_path)}
    before{create_list(:article,user_count)}
    let(:user_count){3}
    fit "全てのarticleが取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.count).to eq user_count
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user", "article_likes", "comments"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      expect(response).to have_http_status(200)
    end
  end
end
