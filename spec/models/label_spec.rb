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

      label.name = Faker::Alphanumeric.alphanumeric(Label::NAME_SIZE_MAX + 1)
      expect(label.valid?).to eq(false)
    end

    it "名前の前後の空白はバリデーション時に削除される" do
      label = FactoryBot.create(:label)
      expect(label.valid?).to eq(true)

      label.name = " " + Faker::Alphanumeric.alphanumeric(Label::NAME_SIZE_MAX) + " "
      expect(label.valid?).to eq(true)
      expect(label.name.strip).to eq(label.name)
    end
  end
end
