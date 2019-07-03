require "rails_helper"

describe Task, type: :model do
  let(:task) { FactoryBot.create(:task) }

  describe "名前のバリデーション" do
    context "30文字以上の場合に" do
      it "バリデーションエラーが発生する" do
        task.name = Faker::String.random(29)
        expect(task.valid?).to eq(true)

        task.name = Faker::String.random(30)
        expect(task.valid?).to eq(true)

        task.name = Faker::String.random(31)
        expect(task.valid?).to eq(false)
      end
    end
  end
end
