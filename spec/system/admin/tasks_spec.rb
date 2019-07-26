require "rails_helper"

describe "管理者/タスク一覧", type: :system do
  let!(:user) { FactoryBot.create(:user, admin: true) }

  before do
    login_by(user)
  end

  describe "検索フォーム" do
    it "検索フォームからユーザーのタスク一覧ページに遷移されない" do
      expected_path = admin_user_tasks_path(user)
      visit(expected_path)
      fill_in(:search_by_name, with: "hoge")
      click_on(I18n.t("helpers.submit.search"))

      expect(page).to have_current_path(Regexp.new(expected_path))
    end
  end

  describe "ラベルでの検索" do
    let!(:task) { FactoryBot.create_list(:task, 3, user: user) }
    let!(:label) { FactoryBot.create_list(:label, 3, user: user) }

    before do
      task[0].labels = [label[0], label[1]]
      task[1].labels = [label[1]]
      task[2].labels = [label[2]]
    end

    it "指定したラベルをもつタスクのみが表示される" do
      visit(admin_user_tasks_path(user))
      find(class: /search-form label_id-#{label[1].id}/).check
      click_on(I18n.t("helpers.submit.search"))
      tasks = all(id: /\Atask-name-(\d+)\z/).collect(&:text)

      expect(tasks).to include(task[0].name)
      expect(tasks).to include(task[1].name)
      expect(tasks).not_to include(task[2].name)
    end
  end
end
