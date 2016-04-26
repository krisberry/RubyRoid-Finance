class Event < ActiveRecord::Base
  attr_accessor :add_all_users, :calculate_amount

  enum paid_type: { free: "free", paid: "paid" }
  
  belongs_to :creator, class_name: "User"
  has_one :budget, inverse_of: :event, dependent: :destroy

  has_many :payments
  has_many :participants, class_name: "User", through: :payments



  accepts_nested_attributes_for :budget
  validates :name, :description, :date, presence: true
  validates_associated :budget

  scope :unpaid, ->{ includes(budget: [:payments]).where('payments.user_id = events_users.user_id AND payments.amount < 0').references(:budget) }

  def select_all_participants
    self.participants = User.all
  end

  def default_budget
    (budget || create_budget).amount = participants.inject(0) { |sum, p| sum + p.money_rate }
  end
end
