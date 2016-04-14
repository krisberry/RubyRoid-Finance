class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.decimal :amount
      t.belongs_to :event, index: true

      t.timestamps null: false
    end
  end
end
