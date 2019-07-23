require "rails_helper"

describe "ラベル機能", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    login_by(user)
  end

  describe "ラベル一覧ページ" do
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

  describe "ラベル編集" do
    it "アプリからラベルの編集ができる" do
      label = FactoryBot.create(:label, user: user)
      visit(labels_path)
      click_link(href: edit_label_path(label))
      update_label(name: "")
      within("#error_explanation") { expect(page).to have_content("ラベル名を入力してください") }

      update_label(name: "適当なラベル名")

      labels = all(id: /\Alabel-name-(?:\d+)\z/).collect(&:text)
      expect(labels).to include("適当なラベル名")
    end
  end

  describe "ラベル削除" do
    it "アプリからラベルの削除ができる" do
      label = FactoryBot.create(:label, user: user)
      visit(labels_path)

      labels = all(id: /\Alabel-name-(?:\d+)\z/).collect(&:text)
      expect(labels).to include(label.name)

      click_on(I18n.t("helpers.delete.button"))
      page.driver.browser.switch_to.alert.accept

      labels = all(id: /\Alabel-name-(?:\d+)\z/).collect(&:text)
      expect(labels).not_to include(label.name)
    end
  end
end
