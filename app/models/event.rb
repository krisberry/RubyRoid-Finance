class Event < ActiveRecord::Base
  before_save :select_all_participants, if: :add_all_users?
  before_save :default_budget, if: :calculate_amount?
  
  enum paid_type: { free: "free", paid: "paid" }
  
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_one :budget, inverse_of: :event, dependent: :destroy
  has_many :payments, through: :budget
  has_and_belongs_to_many :participants, class_name: "User"
  # has_and_belongs_to_many :celebrators, class_name: "User"
  
  accepts_nested_attributes_for :budget

  validates :name, :description, :date, presence: true
  validates_associated :budget

  scope :unpaid, ->{ includes(budget: [:payments]).where('payments.user_id = events_users.user_id AND payments.amount < 0').references(:budget) }

  def select_all_participants
    self.participants = User.all
  end

  def default_budget
    (budget || create_budget).tap do |b|
      b.amount = participants.inject(0) { |sum, p| sum + p.money_rate } if paid?
      b.save
    end
  end
end
