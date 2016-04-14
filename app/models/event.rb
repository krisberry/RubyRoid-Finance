class Event < ActiveRecord::Base
  enum paid_type: { free: "free", paid: "paid" }
  validates :name, presence: true
  
  has_and_belongs_to_many :participants, class_name: "User"
  belongs_to :creator, class_name: "User", foreign_key: "user_id" 
end
