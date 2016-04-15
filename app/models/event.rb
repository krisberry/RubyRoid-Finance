class Event < ActiveRecord::Base
  attr_accessor :select_all, :default_amount
  enum paid_type: { free: "free", paid: "paid" }
  
  has_and_belongs_to_many :participants, class_name: "User"
  has_and_belongs_to_many :celebrators, class_name: "User"
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_one :budget, inverse_of: :event, dependent: :destroy
  accepts_nested_attributes_for :budget

  validates :name, :description, presence: true
  validates_associated :budget

  def select_all_participants
    self.participants = User.all
  end

  def default_budget
    budget.amount = participants.inject(0) { |sum, p| sum + p.money_rate }
  end
end
