require "rails_helper"

describe "タスク管理機能", type: :system do
  let!(:user_a) { FactoryBot.create(:user, login_id: "UserA") }

  before do
    login_by(user_a)
  end

  describe "一覧表示機能" do
    before do
      FactoryBot.create(:task, name: "ユーザーAのタスク", user: user_a)
      FactoryBot.create(:task, name: "適当なタスク")
    end

    it "ユーザーAのタスクのみが表示される" do
      visit(tasks_path)
      expect(page).to have_content("ユーザーAのタスク")
      expect(page).not_to have_content("適当なタスク")
    end
  end

  describe "一覧表示機能" do
    describe "作成日順ソート" do
      let!(:task_a) { FactoryBot.create(:task, user: user_a, name: "タスクA", created_at: Time.zone.now) }
      let!(:task_b) { FactoryBot.create(:task, user: user_a, name: "タスクB", created_at: 1.day.ago) }
      let!(:task_c) { FactoryBot.create(:task, user: user_a, name: "タスクC", created_at: 1.day.from_now) }

      context "初期状態の場合" do
        it "作成日順に並んでいる" do
          visit(tasks_path)
          # "task-name-{タスクのID}"であるidタグが付いている項目を取得
          tasks = all(id: /\Atask-name-(\d+)\z/)
          expect(tasks[0]).to have_content(task_c.name)
          expect(tasks[1]).to have_content(task_a.name)
          expect(tasks[2]).to have_content(task_b.name)
        end
      end
    end

    describe "終了期日順ソート" do
      let!(:task_a) { FactoryBot.create(:task, user: user_a, name: "タスクA", deadline: nil) }
      let!(:task_b) { FactoryBot.create(:task, user: user_a, name: "タスクB", deadline: 2.day.from_now) }
      let!(:task_c) { FactoryBot.create(:task, user: user_a, name: "タスクC", deadline: 3.day.from_now) }

      context "終了期日を一回クリックすると" do
        it "終了期日の昇順ソートになる" do
          visit(tasks_path)
          click_on(Task.human_attribute_name(:deadline))
          # クリックしてからページが読み込まれるまでに多少のウェイト入れないとtasksの取得ができない時がある
          sleep 1
          # "task-name-{タスクのID}"であるidタグが付いている項目を取得
          tasks = all(id: /\Atask-name-(\d+)\z/)
          expect(tasks[0]).to have_content(task_b.name)
          expect(tasks[1]).to have_content(task_c.name)
          expect(tasks[2]).to have_content(task_a.name)
        end
      end

      context "終了期日を二回クリックすると" do
        it "終了期日の降順ソートになる" do
          visit(tasks_path)
          click_on(Task.human_attribute_name(:deadline))
          click_on(Task.human_attribute_name(:deadline))
          # クリックしてからページが読み込まれるまでに多少のウェイト入れないとtasksの取得ができない時がある
          sleep 1
          # "task-name-{タスクのID}"であるidタグが付いている項目を取得
          tasks = all(id: /\Atask-name-(\d+)\z/)
          expect(tasks[0]).to have_content(task_a.name)
          expect(tasks[1]).to have_content(task_c.name)
          expect(tasks[2]).to have_content(task_b.name)
        end
      end
    end

    describe "優先度順ソート" do
      let!(:task_a) { FactoryBot.create(:task, user: user_a, name: "タスクA", priority: :low) }
      let!(:task_b) { FactoryBot.create(:task, user: user_a, name: "タスクB", priority: :middle) }
      let!(:task_c) { FactoryBot.create(:task, user: user_a, name: "タスクC", priority: :high) }

      context "優先度を一回クリックすると" do
        it "優先度の降順ソートになる" do
          visit(tasks_path)
          click_on(Task.human_attribute_name(:priority))
          # クリックしてからページが読み込まれるまでに多少のウェイト入れないとtasksの取得ができない時がある
          sleep 1
          # "task-name-{タスクのID}"であるidタグが付いている項目を取得
          tasks = all(id: /\Atask-name-(\d+)\z/)
          expect(tasks[0]).to have_content(task_c.name)
          expect(tasks[1]).to have_content(task_b.name)
          expect(tasks[2]).to have_content(task_a.name)
        end
      end

      context "優先度を二回クリックすると" do
        it "優先度の昇順ソートになる" do
          visit(tasks_path)
          click_on(Task.human_attribute_name(:priority))
          click_on(Task.human_attribute_name(:priority))
          # クリックしてからページが読み込まれるまでに多少のウェイト入れないとtasksの取得ができない時がある
          sleep 1
          # "task-name-{タスクのID}"であるidタグが付いている項目を取得
          tasks = all(id: /\Atask-name-(\d+)\z/)
          expect(tasks[0]).to have_content(task_a.name)
          expect(tasks[1]).to have_content(task_b.name)
          expect(tasks[2]).to have_content(task_c.name)
        end
      end
    end

    describe "検索" do
      before do
        FactoryBot.create(:task, user: user_a, name: "タスク", status: :in_progress)
        FactoryBot.create(:task, user: user_a, name: "タスクB", status: :finished)
        FactoryBot.create(:task, user: user_a, name: "C", status: :finished)

        visit(tasks_path)
        fill_in(:search_by_name, with: task_name)
        select(task_status, from: :search_by_status) # rubocop: disable Lint/Void
        click_on(I18n.t("helpers.submit.search"))
      end

      context "名称で検索した場合" do
        let(:task_name) { "タスク" }
        let(:task_status) { "" }

        it "指定したタスク名を持つタスクのみが表示される" do
          tasks = all(id: /\Atask-name-(\d+)\z/).collect(&:text)

          expect(tasks).to include("タスク")
          expect(tasks).to include("タスクB")
          expect(tasks).not_to include("C")
        end
      end

      context "ステータスで検索した場合" do
        let(:task_name) { "" }
        let(:task_status) { Task.statuses_i18n[:finished] }

        it "指定したステータスのタスクのみが表示される" do
          tasks = all(id: /\Atask-name-(\d+)\z/).collect(&:text)

          expect(tasks).not_to include("タスク")
          expect(tasks).to include("タスクB")
          expect(tasks).to include("C")
        end
      end

      context "名称+ステータスで検索した場合" do
        let(:task_name) { "タスク" }
        let(:task_status) { Task.statuses_i18n[:finished] }

        it "全ての条件に一致するタスクのみが表示される" do
          tasks = all(id: /\Atask-name-(\d+)\z/).collect(&:text)

          expect(tasks).to eq(["タスクB"])
        end
      end
    end

    describe "ページネーション" do
      before do
        FactoryBot.create_list(:task, 51, user: user_a)
        visit(tasks_path)
      end

      it "1ページに表示される件数が50" do
        tasks = all(id: /\Atask-name-(\d+)\z/).collect(&:text)

        expect(tasks.size).to eq(50)
      end

      it "ページ移動ができる" do
        click_link(id: "page-next")
        expect(page).to have_current_path(/\?page=/)
      end
    end
  end

  describe "詳細表示機能" do
    let!(:task) { FactoryBot.create(:task, user: user_a, name: "最初のタスク", description: "検証用のタスク") }

    context "タスクの詳細画面を開いた時に" do
      before do
        visit(task_path(task))
      end

      it "最初のタスクの名称が表示される" do
        expect(page).to have_content("最初のタスク")
      end

      it "最初のタスクの説明文が表示される" do
        expect(page).to have_content("検証用のタスク")
      end
    end
  end

  describe "新規登録機能" do
    describe "名称のバリデーション" do
      let!(:attr_name) { Task.human_attribute_name(:name) }

      before do
        visit(new_task_path)
        fill_in(attr_name, with: task_name)
        click_button(I18n.t("helpers.submit.create"))
      end

      context "名前を渡した場合" do
        let(:task_name) { "適当な名前" }

        it "新規登録できる" do
          expect(page).to have_selector(".alert-success", text: "適当な名前")
        end
      end

      context "名前を渡さなかった場合" do
        let(:task_name) { "" }

        it "エラーになる" do
          within("#error_explanation") do
            expect(page).to have_content("#{attr_name}を入力してください")
          end
        end
      end
    end

    describe "終了期限のバリデーション" do
      let!(:attr_name) { Task.human_attribute_name(:name) }
      let!(:attr_deadline) { Task.human_attribute_name(:deadline) }

      before do
        visit(new_task_path)
        fill_in(attr_name, with: "適当な名称")
        fill_in(attr_deadline, with: task_deadline)
        click_button(I18n.t("helpers.submit.create"))
      end

      context "適切な終了期限を設定した場合" do
        let(:task_deadline) { 1.day.from_now }

        it "新規登録できる" do
          expect(page).to have_selector(".alert-success", text: "適当な名称")
        end
      end

      context "適切でない終了期限を設定した場合" do
        let(:task_deadline) { Time.zone.now.to_datetime }

        it "新規登録できない" do
          within("#error_explanation") do
            expect(page).to have_content("#{attr_deadline}は現在時刻以降に設定してください")
          end
        end
      end

      context "終了期限を設定しなかった場合" do
        let(:task_deadline) { nil }

        it "新規登録できる" do
          expect(page).to have_selector(".alert-success", text: "適当な名称")
        end
      end
    end
  end

  describe "更新機能" do
    describe "二通りのタスク編集方法" do
      let!(:task) { FactoryBot.create(:task, user: user_a, name: "最初のタスク") }
      let!(:attr_description) { Task.human_attribute_name(:description) }

      context "一覧画面からタスクの編集画面に移動した時" do
        before do
          visit(tasks_path)
          click_link(href: edit_task_path(task))
          fill_in(attr_description, with: "適当な説明文")
          click_button(I18n.t("helpers.submit.update"))
        end

        it "正常に更新できる" do
          expect(page).to have_selector(".alert-success", text: task.name)
          expect(page).to have_content("適当な説明文")
        end
      end

      context "詳細画面からタスクの編集画面に移動した時" do
        before do
          visit(task_path(task))
          click_on(I18n.t("helpers.edit.button"))
          fill_in(attr_description, with: "さらに適当な説明文")
          click_button(I18n.t("helpers.submit.update"))
        end

        it "正常に更新できる" do
          expect(page).to have_selector(".alert-success", text: task.name)
          expect(page).to have_content("さらに適当な説明文")
        end
      end
    end

    describe "終了期限のバリデーション" do
      let!(:task) { FactoryBot.create(:task, user: user_a, name: "最初のタスク") }
      let!(:attr_deadline) { Task.human_attribute_name(:deadline) }

      before do
        visit(edit_task_path(task))
        fill_in(attr_deadline, with: task_deadline)
        click_button(I18n.t("helpers.submit.update"))
      end

      context "適切な終了期限を設定した場合" do
        let(:task_deadline) { 1.day.from_now }

        it "新規登録できる" do
          expect(page).to have_selector(".alert-success", text: task.name)
        end
      end

      context "適切でない終了期限を設定した場合" do
        let(:task_deadline) { Time.zone.now.to_datetime }

        it "新規登録できない" do
          within("#error_explanation") do
            expect(page).to have_content("#{attr_deadline}は現在時刻以降に設定してください")
          end
        end
      end

      context "終了期限を設定しなかった場合" do
        let(:task_deadline) { nil }

        it "新規登録できる" do
          expect(page).to have_selector(".alert-success", text: task.name)
        end
      end
    end
  end

  describe "削除機能" do
    context "削除ボタンを押した時" do
      let!(:task) { FactoryBot.create(:task, user: user_a, name: "最初のタスク") }

      it "削除できる" do
        visit(task_path(task))
        click_on(I18n.t("helpers.delete.button"))
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_selector(".alert-success", text: "最初のタスク")
      end
    end
  end
end
