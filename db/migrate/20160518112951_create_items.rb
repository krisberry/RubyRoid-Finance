class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.decimal :amount
      t.belongs_to :payment, index: true
      t.belongs_to :event, index: true

      t.timestamps null: false
    end
  end
end
