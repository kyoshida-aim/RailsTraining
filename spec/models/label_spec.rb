require "rails_helper"

describe Label, type: :model do
  describe "名前のバリデーション" do
    it "空の名前は登録できない" do
      label = FactoryBot.create(:label)
      expect(label.valid?).to eq(true)

      label.name = ""
      expect(label.valid?).to eq(false)

      label.name = " "
      expect(label.valid?).to eq(false)
    end

    it "長すぎる名前は登録できない" do
      label = FactoryBot.create(:label)
      expect(label.valid?).to eq(true)

      label.name = Faker::String.random(17)
      expect(label.valid?).to eq(false)
    end
  end
end
