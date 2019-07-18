require "rails_helper"

describe "ユーザー関連機能", type: :system do
  describe "ログイン" do
    let!(:user) { FactoryBot.create(:user, login_id: "UserA") }

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
        fill_in(with: "InvalidLoginId", id: "session_login_id")
        fill_in(with: "InvalidPassword", id: "session_password")
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
    let!(:user) { FactoryBot.create(:user, login_id: "UserA") }

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
    let!(:user) { FactoryBot.create(:user, login_id: "UserA", admin: true) }

    before do
      FactoryBot.create(:user, login_id: "UserB")

      visit(login_path)
      fill_in(with: user.login_id, id: "session_login_id")
      fill_in(with: user.password, id: "session_password")
      click_button(I18n.t("helpers.submit.login"))
    end

    it "一覧画面にユーザーが表示される" do
      visit(admin_users_path)

      # "user-id-{ユーザーのID}"のタグがついた要素を取得し、平文で保存する
      users = all(id: /\Auser-id-(?:\d+)\z/).map(&:text)

      expect(users).to have_content("UserA")
      expect(users).to have_content("UserB")
    end

    context "タスクが登録されている場合" do
      before do
        FactoryBot.create(:task, user: user, name: "タスクA")
        FactoryBot.create(:task, user: user, name: "タスクB")
        FactoryBot.create(:task, user: user, name: "タスクC")
      end

      it "タスク数が表示される" do
        visit(admin_users_path)
        user_a_tasks = find_by_id(/\Anumber-of-tasks-#{user.id}/).text.to_i # rubocop:disable Rails/DynamicFindBy

        expect(user_a_tasks).to eq(3)
      end

      it "ユーザーのタスク一覧が確認できる" do
        visit(admin_user_tasks_path(user.id))

        tasks = all(id: /\Atask-name-(?:\d+)\z/).collect(&:text)
        expect(tasks).to include("タスクA")
        expect(tasks).to include("タスクB")
        expect(tasks).to include("タスクC")
      end

      it "ユーザーのタスク詳細を確認できる" do
        task = Task.find_by(name: "タスクA")
        visit(admin_user_tasks_path(user.id))
        click_on(id: "task-name-#{task.id}")

        expect(page).to have_current_path(admin_user_task_path(user.id, task.id))
      end
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
        let(:login_id) { "UserA" }
        let(:password) { "SomePassword" }
        let(:password_confirmation) { "SomePassword" }

        it "登録に失敗する" do
          within("#error_explanation") do
            expect(page).to have_content("ログインIDはすでに存在します")
          end
        end
      end

      context "ログインIDを入力しなかった場合" do
        let(:login_id) { "" }
        let(:password) { "SomePassword" }
        let(:password_confirmation) { "SomePassword" }

        it "登録に失敗する" do
          within("#error_explanation") do
            expect(page).to have_content("ログインIDを入力してください")
          end
        end
      end

      context "パスワードを入力しなかった場合" do
        let(:login_id) { "SomeUser" }
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
        let(:login_id) { "SomeUser" }
        let(:password) { "SomePassword1" }
        let(:password_confirmation) { "SomePassword2" }

        it "登録に失敗する" do
          within("#error_explanation") do
            expect(page).to have_content("パスワード(確認)とパスワードの入力が一致しません")
          end
        end
      end

      context "ログインIDまたはパスワードに英数字以外が使用されてい場合" do
        let(:login_id) { "適当なユーザー" }
        let(:password) { "適当なパスワード" }
        let(:password_confirmation) { "適当なパスワード" }

        it "登録に失敗する" do
          within("#error_explanation") do
            expect(page).to have_content("ログインIDには英数字のみ使用できます")
            expect(page).to have_content("パスワードには英数字のみ使用できます")
          end
        end
      end

      context "ログインIDとパスワードを正しく入力した場合" do
        let(:login_id) { "NewUser" }
        let(:password) { "NewUserPassword" }
        let(:password_confirmation) { "NewUserPassword" }

        it "登録に成功する" do
          expect(page).to have_selector(".alert-success", text: "ユーザー「NewUser」を作成しました")
        end
      end
    end

    describe "ユーザー編集" do
      before do
        visit(admin_users_path)
        click_link(href: edit_admin_user_path(user))
      end

      it "管理者権限の有無のみが編集できる" do
        # 入力フォームまたはチェックボックスを取得
        editable = all(class: /\Aform-(?:\w+)/).collect(&:text)

        expect(editable).not_to have_content(User.human_attribute_name(:login_id))
        expect(editable).to have_content(User.human_attribute_name(:admin))
        expect(editable).not_to have_content(User.human_attribute_name(:password))
        expect(editable).not_to have_content(User.human_attribute_name(:password_confirmation))
      end
    end

    describe "削除機能" do
      context "削除ボタンを押した時" do
        it "削除できる" do
          visit(admin_users_path)
          click_on(I18n.t("helpers.delete.button"), class: "btn btn-danger user-id-#{user.id}")
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_selector(".alert-success", text: "ユーザー「#{user.login_id}」を削除しました")
        end
      end
    end
  end

  describe "ユーザー詳細画面" do
    let!(:user) { FactoryBot.create(:user, login_id: "UserA", admin: true) }

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
