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

  describe "ラベルのタスクへの振り分け" do
    let!(:user) { FactoryBot.create(:user) }

    it "タスクに対し任意の数のラベルを振り分けられる" do
      task = FactoryBot.create(:task, user: user)
      labels = FactoryBot.create_list(:label, 2, user: user)
      expect(task.labels.size).to eq(0)

      task.labels.append(labels[0])
      expect(task.labels.first).to eq(labels[0])

      task.labels = labels
      expect(task.labels).to match_array(labels)
    end
  end

  describe "ラベル数のバリデーション" do
    let!(:user) { FactoryBot.create(:user) }

    it "一個のタスクに設定できるラベルは10個まで" do
      labels = FactoryBot.create_list(:label, 11, user_id: user.id)
      task = FactoryBot.create(:task, user_id: user.id)

      task.labels = labels[0..9]
      expect(task.valid?).to eq(true)

      task.labels = labels[0..10]
      expect(task.valid?).to eq(false)
    end
  end

  describe "他ユーザーのラベル" do
    let!(:user_a) { FactoryBot.create(:user) }
    let!(:user_b) { FactoryBot.create(:user) }
    let!(:label) { FactoryBot.create(:label, user: user_b) }

    it "他ユーザーのラベルをタスクに設定することはできない" do
      task = FactoryBot.create(:task, user: user_a)

      task.labels.append(label)
      expect { task.save! }.to raise_error(Task::InvalidLabelIdGiven)
    end
  end
end
