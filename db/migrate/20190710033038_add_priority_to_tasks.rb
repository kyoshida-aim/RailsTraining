class AddPriorityToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column(:tasks, :priority, :integer, default: 1, null: false)
  end
end
