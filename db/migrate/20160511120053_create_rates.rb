class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.string :name
      t.decimal :amount
      t.text :description

      t.timestamps null: false
    end

    add_reference :users, :rate, index:true, foreign_key: true

    User::USER_RATES.each do |k, v|
      @rate = Rate.create({name: k, amount:v})
    end
    
    User.find_each do |user|
      user.update_attributes(rate_id: @rate.id)
    end

    remove_column :users, :money_rate, :decimal
  end

  def self.down
    remove_reference :users, :rate
    drop_table :rates
    add_column :users, :money_rate, :decimal
  end
end
