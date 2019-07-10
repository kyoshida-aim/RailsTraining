class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :login_id, null:false
      t.string :password_digest, null:false

      t.timestamps
      t.index :login_id, unique: true
    end
  end
end
