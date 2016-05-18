class DropBudgets < ActiveRecord::Migration
  def change
    remove_reference :budgets, :event
    remove_reference :payments, :budget
    drop_table :budgets
    add_column :events, :amount, :decimal
    add_reference :payments, :event, index:true, foreign_key: true
  end
end
