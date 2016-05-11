class AddSocialColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_url, :string
    add_column :users, :github_url, :string
    add_column :users, :linkedin_url, :string
  end
end
