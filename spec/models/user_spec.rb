require "rails_helper"

describe User, type: :model do
  describe "管理者権限" do
    context "ユーザーの管理権限の初期設定" do
      it "管理権限を持たない" do
        expect(User.new.admin).to eq(false)
      end
    end
  end

  describe "ログインIDのバリデーション" do
    before do
      FactoryBot.create(:user, login_id: "UserA")
    end

    let!(:user) { FactoryBot.create(:user) }
    it "既存のユーザーIDと重複するIDは登録できない" do
      user.login_id = "UserA"
      expect(user.valid?).to eq(false)

      user.login_id = "UserB"
      expect(user.valid?).to eq(true)
    end
  end

  describe "更新のバリデーション" do
    it "管理者が他にいなくなる編集を行えない" do
      admin_user = FactoryBot.create(:user, admin: true)

      expect(admin_user.valid?).to eq(true)
      expect(User.where(admin: true).size).to eq(1)

      admin_user.admin = false
      expect(admin_user.valid?).to eq(false)
      error_detail = admin_user.errors.details[:admin].first[:error]
      expect(error_detail).to eq(:need_admin)
    end
  end

  describe "削除のバリデーション" do
    it "管理者が他にいなくなる削除を行えない" do
      admin_user = FactoryBot.create(:user, admin: true)

      expect(admin_user.valid?).to eq(true)
      expect(User.where(admin: true).size).to eq(1)

      expect { admin_user.destroy }.to raise_error(Exceptions::UnableToDestroyLastAdmin)
    end
  end
end
