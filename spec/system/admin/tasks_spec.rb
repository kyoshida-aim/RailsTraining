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
end
