class AddDetailsToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :approved, :boolean, default: false
  end
end
