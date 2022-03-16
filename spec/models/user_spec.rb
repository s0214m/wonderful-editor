require "rails_helper"

RSpec.describe User, type: :model do
  context "name,email,passwordを指定している場合" do
    it "userが作られる" do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  context "nameを指定していない場合" do
    it "userが作られない" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      res = user.errors.details[:name][0][:error]
      expect(res).to eq :blank
    end
  end

  context "emailを指定していない場合" do
    it "userが作られない" do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      res = user.errors.details[:email][0][:error]
      expect(res).to eq :blank
    end
  end

  context "passwordを指定していない場合" do
    it "userが作られない" do
      user = build(:user, password: nil)
      expect(user).to be_invalid
      res = user.errors.details[:password][0][:error]
      expect(res).to eq :blank
    end
  end

  context "既に指定したemailが存在する場合" do
    before { create(:user, email: "aaa@gmail.com") }

    it "userが作られない" do
      user = build(:user, email: "aaa@gmail.com")
      expect(user).to be_invalid
      res = user.errors.details[:email][0][:error]
      expect(res).to eq :taken
    end
  end
end
