require "rails_helper"

describe "ユーザー関連機能", type: :system do
  describe "ログイン" do
    let!(:user) { FactoryBot.create(:user, login_id: "UserA") }

    context "ユーザーIDとパスワードを正しく入力した場合" do
      it "ログインできる" do
        try_login(login_id: user.login_id, password: user.password)

        expect(page).to have_selector(".alert-success", text: "ログインしました")
        expect(page).to have_current_path(root_path)
      end
    end

    context "存在しないユーザーでログインしようとした場合" do
      it "ログインできない" do
        try_login(login_id: "InvalidLoginId", password: "InvalidPassword")

        expect(page).to have_selector(".alert-warning", text: "ログインに失敗しました")
        expect(page).to have_current_path(login_path)
      end
    end

    context "ユーザーIDが入力されていない場合" do
      it "ログインできない" do
        try_login(login_id: "", password: user.password)

        expect(page).to have_selector(".alert-warning", text: "ログインに失敗しました")
        expect(page).to have_current_path(login_path)
      end
    end

    context "パスワードが入力されていない場合" do
      it "ログインできない" do
        try_login(login_id: user.login_id, password: "")

        expect(page).to have_selector(".alert-warning", text: "ログインに失敗しました")
        expect(page).to have_current_path(login_path)
      end
    end

    context "ログインしていない場合" do
      it "タスク一覧ページからログインページにリダイレクトされる" do
        visit(tasks_path)

        expect(page).to have_current_path(login_path)
      end
    end
  end

  describe "新規登録" do
    before do
      FactoryBot.create(:user, login_id: "UserA")

      visit(login_path)
      click_link(I18n.t("helpers.create.button"))

      fill_in(with: login_id, class: "form-control input-login_id")
      fill_in(with: password, class: "form-control input-password")
      fill_in(with: password_confirmation, class: "form-control input-password_confirmation")
      click_button(I18n.t("helpers.submit.create"))
    end

    context "すでに存在するユーザーと同じログインIDで登録しようとした場合" do
      let(:login_id) { "UserA" }
      let(:password) { "password" }
      let(:password_confirmation) { "password" }

      it "登録に失敗する" do
        within("#error_explanation") do
          expect(page).to have_content("ログインIDはすでに存在します")
        end
      end
    end

    context "フォームが入力されていない" do
      let(:login_id) { "" }
      let(:password) { "" }
      let(:password_confirmation) { "" }

      it "登録に失敗する" do
        within("#error_explanation") do
          expect(page).to have_content("ログインIDを入力してください")
          expect(page).to have_content("パスワードを入力してください")
        end
      end
    end

    context "フォーム入力が不十分" do
      let(:login_id) { "ユーザーA" }
      let(:password) { "passwor" }
      let(:password_confirmation) { "password" }

      it "登録に失敗する" do
        within("#error_explanation") do
          expect(page).to have_content("ログインIDには英数字のみ使用できます")
          expect(page).to have_content("パスワードは8文字以上で入力してください")
          expect(page).to have_content("パスワード(確認)とパスワードの入力が一致しません")
        end
      end
    end

    context "新規ユーザー情報が正しく入力されている場合" do
      let(:login_id) { "UserB" }
      let(:password) { "password" }
      let(:password_confirmation) { "password" }

      it "新規登録できる" do
        expect(page).to have_selector(".alert-success", text: "登録に成功しました")
      end
    end
  end

  describe "登録情報修正" do
    let!(:user) { FactoryBot.create(:user, login_id: "UserA", password: "password") }
    before do
      login_by(user)
      click_link(class: "nav-link user_edit")

      # フォーム入力・更新
      fill_in(with: login_id, class: "form-control input-login_id")
      fill_in(with: password, class: "form-control input-password")
      fill_in(with: password_confirmation, class: "form-control input-password_confirmation")
      click_button(I18n.t("helpers.submit.update"))
    end

    context "フォームが入力されていない場合" do
      let(:login_id) { "" }
      let(:password) { "" }
      let(:password_confirmation) { "" }

      it "登録に失敗する" do
        within("#error_explanation") do
          expect(page).to have_content("ログインIDを入力してください")
        end
      end
    end

    context "フォーム入力が不十分" do
      let(:login_id) { "ユーザーA" }
      let(:password) { "passwor" }
      let(:password_confirmation) { "password" }

      it "登録に失敗する" do
        within("#error_explanation") do
          expect(page).to have_content("ログインIDには英数字のみ使用できます")
          expect(page).to have_content("パスワードは8文字以上で入力してください")
          expect(page).to have_content("パスワード(確認)とパスワードの入力が一致しません")
        end
      end
    end

    context "ユーザー情報が正しく入力されている場合" do
      let(:login_id) { "UserB" }
      let(:password) { "password" }
      let(:password_confirmation) { "password" }

      it "正しく更新できる" do
        expect(page).to have_selector(".alert-success", text: "ユーザー情報を更新しました")
      end
    end
  end

  describe "ログアウト" do
    let!(:user) { FactoryBot.create(:user, login_id: "UserA") }

    before do
      login_by(user)
    end

    it "ログアウトし、ログインページに遷移される" do
      click_link(I18n.t("helpers.logout.name"))

      expect(page).to have_selector(".alert-success", text: "ログアウトしました")
      expect(page).to have_current_path(login_path)
    end
  end
end
