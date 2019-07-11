class AddUseridToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference(:tasks, :user, null: false, index: true)
  end
end
