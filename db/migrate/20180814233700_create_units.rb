class CreateUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :units do |t|
      t.integer :monthly_rent, null: false
      t.boolean :vacancy, default: false
      t.integer :annual_rent, null: false
      t.integer :unit_number
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :property_id, null: false

      t.timestamps
    end
    add_index :units, :property_id
  end
end
