class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :properties do |t|
      t.string :address, null: false
      t.integer :cap_rate, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
    add_index :properties, :user_id
  end
end
