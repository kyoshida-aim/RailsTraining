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

  describe "登録数の制限" do
    it "一人のユーザーが持てるラベルの数は20まで" do
      user = FactoryBot.create(:user)
      user.labels = FactoryBot.create_list(:label, 20, user: user)

      new_label_a = user.labels.create(name: "適当な名前")
      expect(new_label_a.persisted?).to eq(true)

      new_label_b = user.labels.create(name: "適当な名前")
      expect(new_label_b.persisted?).to eq(false)
    end
  end
end
