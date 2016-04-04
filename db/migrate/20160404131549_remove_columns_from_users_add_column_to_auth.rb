class RemoveColumnsFromUsersAddColumnToAuth < ActiveRecord::Migration
  def change
    add_column :authorizations, :secret, :string
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
  end
end
