class CreateLabelMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :label_maps do |t|
      t.belongs_to :label, index: true
      t.belongs_to :task,  index: true

      t.timestamps
    end
  end
end
