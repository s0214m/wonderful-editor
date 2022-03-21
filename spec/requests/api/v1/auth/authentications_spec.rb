require "rails_helper"

RSpec.describe "Api::V1::Auth::Authentications", type: :request do
  # sign_up
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
  # sign_in

  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "メールアドレス、パスワードが正しい場合" do
      let(:sign_in_user) { create(:user) }
      let(:params) { { email: sign_in_user.email, password: sign_in_user.password } }
      it "ログインできる" do
        subject
        expect(response.headers["uid"]).to be_present
        expect(response.headers["access-token"]).to be_present
        expect(response.headers["client"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "メールアドレスがない場合" do
      let(:sign_in_user) { create(:user) }
      let(:params) { { email: "", password: sign_in_user.password } }
      it "sign_inできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to eq false
        expect(res["errors"]).to eq ["Invalid login credentials. Please try again."]
        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["uid"]).to eq nil
        expect(response.headers["access-token"]).to eq nil
        expect(response.headers["client"]).to eq nil
      end
    end

    context "メールアドレスが間違っている場合" do
      let(:sign_in_user) { create(:user) }
      let(:params) { { email: "test@example.com", password: sign_in_user.password } }
      it "sign_inできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to eq false
        expect(res["errors"]).to eq ["Invalid login credentials. Please try again."]
        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["uid"]).to eq nil
        expect(response.headers["access-token"]).to eq nil
        expect(response.headers["client"]).to eq nil
      end
    end

    context "パスワードがない場合" do
      let(:sign_in_user) { create(:user) }
      let(:params) { { email: sign_in_user.email, password: "" } }
      it "sign_inできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to eq false
        expect(res["errors"]).to eq ["Invalid login credentials. Please try again."]
        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["uid"]).to eq nil
        expect(response.headers["access-token"]).to eq nil
        expect(response.headers["client"]).to eq nil
      end
    end

    context "パスワードが間違っている場合" do
      let(:sign_in_user) { create(:user) }
      let(:params) { { email: sign_in_user.email, password: "test1234" } }
      it "sign_inできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to eq false
        expect(res["errors"]).to eq ["Invalid login credentials. Please try again."]
        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["uid"]).to eq nil
        expect(response.headers["access-token"]).to eq nil
        expect(response.headers["client"]).to eq nil
      end
    end
  end
  # sign_out

  describe " DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "ログアウトに必要な情報を送ったとき" do
      let(:sign_in_user) { create(:user) }
      let!(:headers) { sign_in_user.create_new_auth_token }
      it "ログアウトできる" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to eq true
        expect(response.headers["uid"]).to eq nil
        expect(response.headers["access-token"]).to eq nil
        expect(response.headers["client"]).to eq nil
      end
    end

    context "誤った情報を送った時" do
      let(:sign_in_user) { create(:user) }
      let!(:headers) { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" } }
      it "ログアウトできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to eq false
        expect(res["errors"]).to eq ["User was not found or was not logged in."]
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
