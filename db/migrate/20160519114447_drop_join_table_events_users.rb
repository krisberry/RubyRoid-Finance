class DropJoinTableEventsUsers < ActiveRecord::Migration
  def self.up
    drop_table :events_users
  end

  def self.down
    create_table :events_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :event, index: true
    end
  end
end
