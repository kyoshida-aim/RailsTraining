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
end
