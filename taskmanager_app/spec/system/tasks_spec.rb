require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク') }

  describe '一覧表示機能' do
    it '一覧表示のページで最初のタスクが表示される' do
      visit(tasks_path)
      expect(page).to have_content('最初のタスク')
    end
  end

  describe '詳細表示機能' do
    it '最初のタスクの詳細が表示される' do
      visit(tasks_path(task_a))
      expect(page).to have_content('最初のタスク')
    end
  end

  describe '新規登録機能' do
    attribute_name = Task.human_attribute_name(:name)

    before do
      visit(new_task_path)
      fill_in(attribute_name, with: task_name)
      click_button(I18n.t('helpers.submit.create'))
    end

    context '名前を渡した場合' do
      let(:task_name) { '適当な名前' }

      it '新規登録できる' do
        expect(page).to have_selector '.alert-success', text: '適当な名前'
      end
    end

    context '名前を渡さなかった場合' do
      let(:task_name) { '' }

      it 'エラーになる' do
        within('#error_explanation') do
          expect(page).to have_content("#{attribute_name}を入力してください")
        end
      end
    end
  end
end
