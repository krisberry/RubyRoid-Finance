class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :imageable_id
      t.string :imageable_type
      t.timestamps null: false
      t.attachment :photo
    end
  end
end
