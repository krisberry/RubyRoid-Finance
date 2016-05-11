class CreateJoinTableCelebratorEvent < ActiveRecord::Migration
  def change
    create_join_table :celebrators, :events do |t|
      t.index [:celebrator_id, :event_id]
      # t.index [:event_id, :celebrator_id]
    end
  end
end
