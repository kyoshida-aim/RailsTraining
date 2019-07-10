class AddStatusColumnToTask < ActiveRecord::Migration[5.2]
  def up
    add_column(:tasks, :status, :integer, default: 0)
  end

  def down
    remove_column(:tasks, :status, :integer, default: 0)
  end
end
