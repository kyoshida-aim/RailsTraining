require "rails_helper"

describe "ラベル機能", type: :system do
  describe "ラベル一覧ページ" do
    let!(:user) { FactoryBot.create(:user) }

    before do
      login_by(user)
    end

    it "ユーザーのラベルが全て表示される" do
      label1 = FactoryBot.create(:label, name: "ユーザーAのラベル1", user: user)
      label2 = FactoryBot.create(:label, name: "ユーザーAのラベル2", user: user)
      label3 = FactoryBot.create(:label, name: "ユーザーAのではないラベル")

      visit(labels_path)
      labels = all(id: /\Alabel-name-(?:\d+)\z/).collect(&:text)

      expect(labels).to include(label1.name, label2.name)
      expect(labels).not_to include(label3.name)
    end
  end

  describe "ラベル新規登録" do
    let!(:user) { FactoryBot.create(:user) }

    before do
      login_by(user)
    end

    it "アプリから新規ラベルの作成ができる" do
      visit(new_label_path)

      register_label(name: "")
      within("#error_explanation") { expect(page).to have_content("ラベル名を入力してください") }

      register_label(name: "適当なラベル名")

      labels = all(id: /\Alabel-name-(?:\d+)\z/).collect(&:text)
      expect(labels).to include("適当なラベル名")
      expect(labels).not_to include("")
    end
  end
end
