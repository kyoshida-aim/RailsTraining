require "rails_helper"

describe "ユーザー管理機能", type: :system do
  context "管理権限を持たない場合" do
    let!(:user) { FactoryBot.create(:user, login_id: "UserA", admin: false) }

    it "管理ページへのリンクが表示されない" do
      login_by(user)

      expect(page).not_to have_link(href: admin_users_path)
    end

    it "管理ページへのアクセスできない" do
      login_by(user)
      visit(admin_users_path)
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe "ユーザー一覧画面" do
    let!(:user) { FactoryBot.create(:user, login_id: "UserA", admin: true) }

    before do
      login_by(user)
    end

    it "一覧画面にユーザーが表示される" do
      FactoryBot.create(:user, login_id: "UserB")

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
      context "すでに存在するログインIDで登録しようとした場合" do
        it "登録に失敗する" do
          visit(new_admin_user_path)
          register_user(login_id: "UserA", password: "SomePassword", password_confirmation: "SomePassword")

          within("#error_explanation") do
            expect(page).to have_content("ログインIDはすでに存在します")
          end
        end
      end

      context "フォームを入力しなかった場合" do
        it "登録に失敗する" do
          visit(new_admin_user_path)
          register_user(login_id: "", password: "", password_confirmation: "")

          within("#error_explanation") do
            expect(page).to have_content("ログインIDを入力してください")
            expect(page).to have_content("パスワードを入力してください")
          end
        end
      end

      context "ログインIDが4文字より少ないの時" do
        it "登録に失敗する" do
          visit(new_admin_user_path)
          register_user(login_id: "A", password: "password", password_confirmation: "password")

          within("#error_explanation") do
            expect(page).to have_content("ログインIDは4文字以上で入力してください")
          end
        end
      end

      context "ログインIDが20文字より多い時" do
        it "登録に失敗する" do
          visit(new_admin_user_path)
          register_user(login_id: "ABCDEFGHIJKLMNOPQRSTU", password: "password", password_confirmation: "password")

          within("#error_explanation") do
            expect(page).to have_content("ログインIDは20文字以内で入力してください")
          end
        end
      end

      context "パスワードが正しく入力されていない場合" do
        it "登録に失敗する" do
          visit(new_admin_user_path)
          register_user(login_id: "SomeUser", password: "smlpass", password_confirmation: "smallpass")

          within("#error_explanation") do
            expect(page).to have_content("パスワードは8文字以上で入力してください")
            expect(page).to have_content("パスワード(確認)とパスワードの入力が一致しません")
          end
        end
      end

      context "ログインIDまたはパスワードに英数字以外が使用されてい場合" do
        it "登録に失敗する" do
          visit(new_admin_user_path)
          register_user(login_id: "適当なユーザー", password: "適当なパスワード", password_confirmation: "適当なパスワード")

          within("#error_explanation") do
            expect(page).to have_content("ログインIDには英数字のみ使用できます")
            expect(page).to have_content("パスワードには英数字のみ使用できます")
          end
        end
      end

      context "ログインIDとパスワードを正しく入力した場合" do
        it "登録に成功する" do
          visit(new_admin_user_path)
          register_user(login_id: "NewUser", password: "NewUserPassword", password_confirmation: "NewUserPassword")

          users = all(id: /\Auser-id-(?:\d+)\z/).collect(&:text)

          expect(page).to have_selector(".alert-success", text: "ユーザー「NewUser」を作成しました")
          expect(page).to have_current_path(admin_users_path)
          expect(users).to include("NewUser")
        end
      end
    end

    describe "管理権限の編集" do
      it "管理者権限の有無のみが編集できる" do
        visit(admin_users_path)
        click_link(href: edit_admin_user_path(user))

        # 入力フォームまたはチェックボックスを取得
        editable = all(class: /\Aform-(?:\w+)/).collect(&:text)

        expect(editable).not_to have_content(User.human_attribute_name(:login_id))
        expect(editable).to have_content(User.human_attribute_name(:admin))
        expect(editable).not_to have_content(User.human_attribute_name(:password))
        expect(editable).not_to have_content(User.human_attribute_name(:password_confirmation))
      end

      it "管理者権限を無しからありに変更" do
        user = FactoryBot.create(:user, admin: false)
        visit(edit_admin_user_path(user))
        checked = find(class: /input-admin/).checked?

        expect(checked).to eq(false) # なし

        check(class: /input-admin/)
        click_button(I18n.t("helpers.submit.update"))

        user_admin = find_by_id(/\Auser-id-#{user.id}-admin\z/) # rubocop:disable Rails/DynamicFindBy

        expect(user_admin.text).to eq("あり")
      end

      context "他に管理者がいる場合" do
        let!(:user_to_edit) { FactoryBot.create(:user, admin: true) }

        it "管理権限を消せる" do
          login_by(user_to_edit)
          visit(edit_admin_user_path(user_to_edit))
          checked = find(class: /input-admin/).checked?

          expect(checked).to eq(true) # あり

          uncheck(class: /input-admin/)
          click_button(I18n.t("helpers.submit.update"))

          expect(page).to have_current_path(root_path)
          expect(page).not_to have_link(admin_users_path)
        end
      end

      context "他に管理者がいない場合" do
        it "管理者権限を持つものがいなくなる編集を行えない" do
          visit(edit_admin_user_path(user))
          uncheck(class: /input-admin/)
          click_button(I18n.t("helpers.submit.update"))

          within("#error_explanation") do
            expect(page).to have_content("管理者権限をもつユーザーは一人以上存在しなければなりません")
          end

          expect(user.admin).to eq(true)
        end
      end
    end

    describe "削除機能" do
      context "管理者が他にいる場合" do
        let!(:user_to_delete) { FactoryBot.create(:user, admin: true) }

        it "削除できる" do
          visit(admin_users_path)
          click_on(I18n.t("helpers.delete.button"), class: "btn btn-danger user-id-#{user_to_delete.id}")
          page.driver.browser.switch_to.alert.accept
          users = all(id: /\Auser-id-(?:\d+)\z/).collect(&:text)

          expect(page).to have_selector(".alert-success", text: "ユーザー「#{user_to_delete.login_id}」を削除しました")
          expect(users).not_to include(user_to_delete.login_id)
        end
      end

      context "削除対象が管理者でない場合" do
        let!(:user_to_delete) { FactoryBot.create(:user, admin: false) }

        it "削除できる" do
          visit(admin_users_path)
          click_on(I18n.t("helpers.delete.button"), class: "btn btn-danger user-id-#{user_to_delete.id}")
          page.driver.browser.switch_to.alert.accept
          users = all(id: /\Auser-id-(?:\d+)\z/).collect(&:text)

          expect(page).to have_selector(".alert-success", text: "ユーザー「#{user_to_delete.login_id}」を削除しました")
          expect(users).not_to include(user_to_delete.login_id)
        end
      end

      context "削除対象が唯一の管理者である場合" do
        let!(:user_to_delete) { user }

        it "削除できない" do
          visit(admin_users_path)
          click_on(I18n.t("helpers.delete.button"), class: "btn btn-danger user-id-#{user_to_delete.id}")
          page.driver.browser.switch_to.alert.accept
          users = all(id: /\Auser-id-(?:\d+)\z/).collect(&:text)

          expect(page).to have_selector(".alert-warning", text: "ユーザーの削除に失敗しました")
          expect(users).to include(user_to_delete.login_id)
        end
      end
    end
  end

  describe "ユーザー詳細画面" do
    let!(:user) { FactoryBot.create(:user) }

    before do
      login_by(user)
    end

    it "ユーザー詳細画面が表示される" do
      visit(admin_user_path(user))

      expect(page).to have_current_path(admin_user_path(user))
    end
  end
end
