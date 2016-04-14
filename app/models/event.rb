class Event < ActiveRecord::Base
  enum paid_type: { free: "free", paid: "paid" }
  
  has_and_belongs_to_many :participants, class_name: "User"
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_one :budget, inverse_of: :event, dependent: :destroy
  accepts_nested_attributes_for :budget

  validates :name, :description, presence: true
  validates_associated :budget
end
