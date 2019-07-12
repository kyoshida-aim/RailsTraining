require "rails_helper"

describe "ユーザー関連機能", type: :system do
  describe "ログイン" do
    let!(:user) { FactoryBot.create(:user, login_id: "ユーザーA") }

    context "ユーザーIDとパスワードを正しく入力した場合" do
      it "ログインできる" do
        visit(login_path)
        fill_in(with: user.login_id, id: "session_login_id")
        fill_in(with: user.password, id: "session_password")
        click_button(I18n.t("helpers.submit.login"))

        expect(page).to have_selector(".alert-success", text: "ログインしました")
      end
    end

    context "存在しないユーザーでログインしようとした場合" do
      it "ログインできない" do
        visit(login_path)
        fill_in(with: "不正なユーザー名", id: "session_login_id")
        fill_in(with: "不正なパスワード", id: "session_password")
        click_button(I18n.t("helpers.submit.login"))

        expect(page).to have_selector(".alert-warning", text: "ログインに失敗しました")
      end
    end

    describe "正しく入力しないユーザーをログインさせない" do
      before do
        visit(login_path)
        fill_in(with: login_id, id: "session_login_id")
        fill_in(with: password, id: "session_password")
        click_button(I18n.t("helpers.submit.login"))
      end

      context "ユーザーIDが入力されていない場合" do
        let(:login_id) { "" }
        let(:password) { user.password }

        it "ログインできない" do
          expect(page).to have_selector(".alert-warning", text: "ログインに失敗しました")
        end
      end

      context "パスワードが入力されていない場合" do
        let(:login_id) { user.login_id }
        let(:password) { "" }

        it "ログインできない" do
          expect(page).to have_selector(".alert-warning", text: "ログインに失敗しました")
        end
      end
    end

    context "ログインしていない場合" do
      it "タスク一覧ページからログインページにリダイレクトされる" do
        visit(tasks_path)

        expect(page).to have_current_path(%r{/login})
      end
    end
  end

  describe "ログアウト" do
    let!(:user) { FactoryBot.create(:user, login_id: "ユーザーA") }

    before do
      visit(login_path)
      fill_in(with: user.login_id, id: "session_login_id")
      fill_in(with: user.password, id: "session_password")
      click_button(I18n.t("helpers.submit.login"))
    end

    it "ログアウトし、ログインページに遷移される" do
      click_link(I18n.t("helpers.logout.name"))

      expect(page).to have_selector(".alert-success", text: "ログアウトしました")
      expect(page).to have_current_path(%r{/login})
    end
  end
end
