class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.string :name
      t.decimal :amount
      t.text :description

      t.timestamps null: false
    end

    add_reference :users, :rate, index:true, foreign_key: true
    remove_column :users, :money_rate, :decimal
  end

  def self.down
    remove_reference :users, :rate
    drop_table :rates
    add_column :users, :money_rate, :decimal
  end
end
