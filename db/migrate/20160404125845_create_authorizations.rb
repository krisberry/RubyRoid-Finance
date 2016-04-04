class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.string :token

      t.timestamps null: false
    end
    add_reference :authorizations, :user, index: true
  end
end
