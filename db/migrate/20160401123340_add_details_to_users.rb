class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthday, :datetime
    add_column :users, :phone, :string
    add_column :users, :role, :string, default: '2'
    add_column :users, :invited_code, :string
  end
end
