class Event < ActiveRecord::Base
  enum type: { free: "free", paid: "paid" }
  has_and_belongs_to_many :users
end
