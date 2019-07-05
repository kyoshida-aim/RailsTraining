class AddDeadlineColumnToTasks < ActiveRecord::Migration[5.2]
  def up
    add_column(:tasks, :deadline, :datetime)
  end

  def down
    remove_column(:tasks, :deadline, :datetime)
  end
end
