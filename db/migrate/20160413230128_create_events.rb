class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :date
      t.string :paid_type, default: "free"
      t.belongs_to :user, index: true

      t.timestamps null: false
    end    
  end
end
