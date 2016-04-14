class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.string :type, default: "free"
      t.decimal :price
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
