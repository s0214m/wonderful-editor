require "rails_helper"

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    let(:params) { attributes_for(:user) }
    context "適切なデータを送信したとき" do
      it "userが作成される" do
        expect { subject }.to change { User.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "success"
        expect(res["data"]["name"]).to eq params[:name]
        expect(res["data"]["email"]).to eq params[:email]
        expect(response.header["access-token"]).to be_present
        expect(response.header["uid"]).to be_present
        expect(response.header["client"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "nameがない場合" do
      let(:params) { attributes_for(:user, name: nil) }
      it "userが作成されない" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "error"
        expect(response.header["access-token"]).to eq nil
        expect(response.header["uid"]).to eq nil
        expect(response.header["client"]).to eq nil
        expect(res["errors"]["name"]).to eq ["can't be blank"]
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "emailがない場合" do
      let(:params) { attributes_for(:user, email: nil) }
      it "userが作成されない" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "error"
        expect(response.header["access-token"]).to eq nil
        expect(response.header["uid"]).to eq nil
        expect(response.header["client"]).to eq nil
        expect(res["errors"]["email"]).to eq ["can't be blank"]
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "passwordがない場合" do
      let(:params) { attributes_for(:user, password: nil) }
      it "userが作成されない" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "error"
        expect(response.header["access-token"]).to eq nil
        expect(response.header["uid"]).to eq nil
        expect(response.header["client"]).to eq nil
        expect(res["errors"]["password"]).to eq ["can't be blank"]
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "既に同じemailが存在する時" do
      let!(:user) { create(:user, email: "001@test.com") }
      let(:params) { attributes_for(:user, email: "001@test.com") }
      it "userが作成されない" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "error"
        expect(response.header["access-token"]).to eq nil
        expect(response.header["uid"]).to eq nil
        expect(response.header["client"]).to eq nil
        expect(res["errors"]["email"]).to eq ["has already been taken"]
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
