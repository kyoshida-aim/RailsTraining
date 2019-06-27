require 'rails_helper'

describe 'タスク管理機能', type: :system do
  task_a = FactoryBot.create(:task, name: '最初のタスク', description: '検証用のタスク')

  shared_examples_for '最初のタスクの名称が表示される' do
    it { expect(page).to have_content('最初のタスク') }
  end

  describe '一覧表示機能' do
    before do
      visit(tasks_path)
    end
    it_behaves_like '最初のタスクの名称が表示される'
  end

  describe '詳細表示機能' do
    before do
      visit(task_path(task_a))
    end
    it_behaves_like '最初のタスクの名称が表示される'

    it '最初のタスクの説明文が表示される' do
      expect(page).to have_content('検証用のタスク')
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
        expect(page).to have_selector('.alert-success', text: '適当な名前')
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
