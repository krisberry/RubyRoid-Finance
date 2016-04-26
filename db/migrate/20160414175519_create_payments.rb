class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.references :participant, index: true
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_foreign_key :payments, :users, column: :participant_id
  end
end
