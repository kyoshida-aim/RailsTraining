require "rails_helper"

describe Label, type: :model do
  describe "名前のバリデーション" do
    it "空の名前は登録できない" do
      label = FactoryBot.create(:label)
      expect(label.valid?).to eq(true)

      label.name = ""
      expect(label.valid?).to eq(false)
    end
  end
end
