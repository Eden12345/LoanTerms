class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.integer :amount, null: false
      t.string :type
      t.integer :property_id, null: false

      t.timestamps
    end
    add_index :expenses, :property_id
  end
end
