class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.string :invited_code
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
