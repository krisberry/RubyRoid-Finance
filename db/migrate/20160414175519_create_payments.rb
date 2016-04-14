class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.belongs_to :user, index: true
      t.belongs_to :budget, index: true

      t.timestamps null: false
    end
  end
end
