require "rails_helper"

describe Task, type: :model do
  describe "名前のバリデーション" do
    let(:task) { FactoryBot.create(:task) }

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

  describe "検索のバリデーション" do
    it "名称を検索に使用できる" do
      # シンボルそのままではincludeによるマッチングに反応しない。Stringだと検索性が落ちる。
      expect(Task.ransackable_attributes).to include(:name.to_s)
    end

    it "ステータスを検索に使用できる" do
      # シンボルそのままではincludeによるマッチングに反応しない。Stringだと検索性が落ちる。
      expect(Task.ransackable_attributes).to include(:status.to_s)
    end
  end
end
