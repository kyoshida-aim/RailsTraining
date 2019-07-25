class RenameLabelMaps < ActiveRecord::Migration[5.2]
  def change
    rename_table(:label_maps, :labels_tasks)
  end
end
