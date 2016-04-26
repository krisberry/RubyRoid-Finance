class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :date
      t.string :paid_type, default: "free"
      t.references :creator, index: true

      t.timestamps null: false
    end 
    add_foreign_key :events, :users, column: :creator_id
  end
end
