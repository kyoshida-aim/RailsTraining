require "rails_helper"

describe User, type: :model do
  describe "管理者権限" do
    let(:user) { FactoryBot.create(:user) }

    context "ユーザーの管理権限の初期設定" do
      it "管理権限を持たない" do
        expect(user.admin).to eq(false)
      end
    end
  end

  describe "ログインIDのバリデーション" do
    before do
      FactoryBot.create(:user, login_id: "ユーザーA")
    end

    let!(:user) { FactoryBot.create(:user) }
    it "既存のユーザーIDと重複するIDは登録できない" do
      user.login_id = "ユーザーA"
      expect(user.valid?).to eq(false)

      user.login_id = "ユーザーB"
      expect(user.valid?).to eq(true)
    end
  end
end
