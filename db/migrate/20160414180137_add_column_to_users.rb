class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :money_rate, :decimal, default: 50
  end
end
