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

  describe "ユーザー一覧画面" do
    let!(:user) { FactoryBot.create(:user, login_id: "ユーザーA", admin: true) }

    before do
      FactoryBot.create(:user, login_id: "ユーザーB")

      visit(login_path)
      fill_in(with: user.login_id, id: "session_login_id")
      fill_in(with: user.password, id: "session_password")
      click_button(I18n.t("helpers.submit.login"))
    end

    it "一覧画面にユーザーが表示される" do
      visit(admin_users_path)

      # "user-id-{ユーザーのID}"のタグがついた要素を取得し、平文で保存する
      users = all(id: /\Auser-id-(?:\d+)\z/).map(&:text)

      expect(users).to have_content("ユーザーA")
      expect(users).to have_content("ユーザーB")
    end

    describe "ユーザー登録" do
      before do
        visit(new_admin_user_path)
        fill_in(with: login_id, class: /\Aform-control input-login_id\z/)
        fill_in(with: password, class: /\Aform-control input-password\z/)
        fill_in(with: password_confirmation, class: /\Aform-control input-password_confirmation\z/)
        click_button(I18n.t("helpers.submit.create"))
      end

      context "すでに存在するログインIDで登録しようとした場合" do
        let(:login_id) { "ユーザーA" }
        let(:password) { "適当なパスワード" }
        let(:password_confirmation) { "適当なパスワード" }

        it "登録に失敗する" do
          within("#error_explanation") do
            expect(page).to have_content("ログインIDはすでに存在します")
          end
        end
      end

      context "ログインIDを入力しなかった場合" do
        let(:login_id) { "" }
        let(:password) { "適当なパスワード" }
        let(:password_confirmation) { "適当なパスワード" }

        it "登録に失敗する" do
          within("#error_explanation") do
            expect(page).to have_content("ログインIDを入力してください")
          end
        end
      end

      context "パスワードを入力しなかった場合" do
        let(:login_id) { "適当なユーザー名" }
        let(:password) { "" }
        let(:password_confirmation) { "" }

        it "登録に失敗する" do
          within("#error_explanation") do
            expect(page).to have_content("パスワードを入力してください")
          end
        end
      end

      context "パスワードが8文字以下の場合" do
        let(:login_id) { "SomeUser" }
        let(:password) { "smlpass" }
        let(:password_confirmation) { "smlpass" }

        it "登録に失敗する" do
          within("#error_explanation") do
            expect(page).to have_content("パスワードは8文字以上で入力してください")
          end
        end
      end

      context "パスワードとパスワード(確認)が一致しない場合" do
        let(:login_id) { "適当なユーザー名" }
        let(:password) { "適当なパスワード1" }
        let(:password_confirmation) { "適当なパスワード2" }

        it "登録に失敗する" do
          within("#error_explanation") do
            expect(page).to have_content("パスワード(確認)とパスワードの入力が一致しません")
          end
        end
      end

      context "ログインIDとパスワードを正しく入力した場合" do
        let(:login_id) { "新しいユーザー名" }
        let(:password) { "新しいユーザーのパスワード" }
        let(:password_confirmation) { "新しいユーザーのパスワード" }

        it "登録に成功する" do
          expect(page).to have_selector(".alert-success", text: "ユーザー「新しいユーザー名」を作成しました")
        end
      end
    end
  end

  describe "ユーザー詳細画面" do
    let!(:user) { FactoryBot.create(:user, login_id: "ユーザーA", admin: true) }

    before do
      visit(login_path)
      fill_in(with: user.login_id, id: "session_login_id")
      fill_in(with: user.password, id: "session_password")
      click_button(I18n.t("helpers.submit.login"))
    end

    it "ユーザー詳細画面が表示される" do
      visit(admin_user_path(user))

      expect(page).to have_current_path(admin_user_path(user))
    end
  end
end
