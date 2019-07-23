require "rails_helper"

describe LabelMap, type: :model do
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
end
