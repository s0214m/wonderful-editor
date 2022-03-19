# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  nickname               :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  context "name,email,passwordを指定している場合" do
    let(:user) { build(:user) }
    it "userが作られる" do
      expect(user).to be_valid
    end
  end

  context "nameを指定していない場合" do
    let(:user) { build(:user, name: nil) }
    it "userが作られない" do
      expect(user).to be_invalid
      res = user.errors.details[:name][0][:error]
      expect(res).to eq :blank
    end
  end

  context "emailを指定していない場合" do
    let(:user) { build(:user, email: nil) }
    it "userが作られない" do
      expect(user).to be_invalid
      res = user.errors.details[:email][0][:error]
      expect(res).to eq :blank
    end
  end

  context "passwordを指定していない場合" do
    let(:user) { build(:user, password: nil) }
    it "userが作られない" do
      expect(user).to be_invalid
      res = user.errors.details[:password][0][:error]
      expect(res).to eq :blank
    end
  end

  context "既に指定したemailが存在する場合" do
    before { create(:user, email: "aaa@gmail.com") }

    let(:user) { build(:user, email: "aaa@gmail.com") }
    it "userが作られない" do
      expect(user).to be_invalid
      res = user.errors.details[:email][0][:error]
      expect(res).to eq :taken
    end
  end
end
