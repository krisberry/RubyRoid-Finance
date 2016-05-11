class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :calculate_amount, :boolean
    add_column :events, :add_all_users, :boolean
  end
end
