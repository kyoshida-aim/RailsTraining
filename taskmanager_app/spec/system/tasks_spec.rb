require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    context '最初のタスクが存在している時' do
      before do
        FactoryBot.create(:task, name: '最初のタスク')
      end
      it '一覧表示のページで最初のタスクが表示される' do
        visit(tasks_path)
        expect(page).to have_content('最初のタスク')
      end
    end
  end
end
