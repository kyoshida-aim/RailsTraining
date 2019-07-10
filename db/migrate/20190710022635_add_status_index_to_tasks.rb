class AddStatusIndexToTasks < ActiveRecord::Migration[5.2]
  def up
    add_index(:tasks, :status)
  end

  def down
    remove_index(:tasks, :status)
  end
end
