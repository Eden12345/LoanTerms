class ChangeIntToDec < ActiveRecord::Migration[5.1]
  def change
    change_column :properties, :cap_rate, :decimal
    change_column :units, :monthly_rent, :decimal
    change_column :units, :annual_rent, :decimal
    change_column :expenses, :amount, :decimal
  end
end
