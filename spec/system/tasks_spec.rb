require "rails_helper"

describe "タスク管理機能", type: :system do
  let!(:task_a) do
    FactoryBot.create(:task, name: "最初のタスク", description: "検証用のタスク")
  end

  describe "一覧表示機能" do
    context "一覧画面に" do
      it "最初のタスクの名称が表示される" do
        visit(tasks_path)
        expect(page).to have_content("最初のタスク")
      end
    end
  end

  describe "一覧表示機能" do
    describe "並び順" do
      let!(:task_a) { FactoryBot.create(:task, name: "タスクA", created_at: Time.zone.now, deadline: nil) }
      let!(:task_b) { FactoryBot.create(:task, name: "タスクB", created_at: 1.day.ago, deadline: 2.day.from_now) }
      let!(:task_c) { FactoryBot.create(:task, name: "タスクC", created_at: 1.day.from_now, deadline: 3.day.from_now) }

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

    describe "検索" do
      let!(:task_a) { FactoryBot.create(:task, name: "タスク", status: "着手中") }
      let!(:task_b) { FactoryBot.create(:task, name: "タスクB", status: "終了済") }
      let!(:task_c) { FactoryBot.create(:task, name: "C", status: "終了済") }

      before do
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

          expect(tasks).to include(task_a.name)
          expect(tasks).to include(task_b.name)
          expect(tasks).not_to include(task_c.name)
        end
      end

      context "ステータスで検索した場合" do
        let(:task_name) { "" }
        let(:task_status) { "終了済" }

        it "指定したステータスのタスクのみが表示される" do
          tasks = all(id: /\Atask-name-(\d+)\z/).collect(&:text)

          expect(tasks).not_to include(task_a.name)
          expect(tasks).to include(task_b.name)
          expect(tasks).to include(task_c.name)
        end
      end

      context "名称+ステータスで検索した場合" do
        let(:task_name) { "タスク" }
        let(:task_status) { "終了済" }

        it "全ての条件に一致するタスクのみが表示される" do
          tasks = all(id: /\Atask-name-(\d+)\z/).collect(&:text)

          expect(tasks).to eq([task_b.name])
        end
      end
    end
  end

  describe "詳細表示機能" do
    context "タスクの詳細画面を開いた時に" do
      before do
        visit(task_path(task_a))
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

  describe "更新機能" do
    let!(:attr_description) { Task.human_attribute_name(:description) }

    context "一覧画面からタスクの編集画面に移動した時" do
      before do
        visit(tasks_path)
        click_link(href: edit_task_path(task_a))
        fill_in(attr_description, with: "適当な説明文")
        click_button(I18n.t("helpers.submit.update"))
      end

      it "正常に更新できる" do
        expect(page).to have_selector(".alert-success", text: task_a.name)
        expect(page).to have_content("適当な説明文")
      end
    end

    context "詳細画面からタスクの編集画面に移動した時" do
      before do
        visit(task_path(task_a))
        click_on(I18n.t("helpers.edit.button"))
        fill_in(attr_description, with: "さらに適当な説明文")
        click_button(I18n.t("helpers.submit.update"))
      end

      it "正常に更新できる" do
        expect(page).to have_selector(".alert-success", text: task_a.name)
        expect(page).to have_content("さらに適当な説明文")
      end
    end
  end

  describe "削除機能" do
    context "削除ボタンを押した時" do
      it "削除できる" do
        visit(task_path(task_a))
        click_on(I18n.t("helpers.delete.button"))
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_selector(".alert-success", text: "最初のタスク")
      end
    end
  end
end
