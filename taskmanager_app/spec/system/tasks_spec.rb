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
