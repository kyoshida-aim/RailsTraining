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
end
