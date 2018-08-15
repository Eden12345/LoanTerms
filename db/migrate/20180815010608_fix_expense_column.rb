class FixExpenseColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :expenses, :type, :expense_type
  end
end
