class Event < ActiveRecord::Base
  before_save :select_all_participants, if: :add_all_users?
  before_save :default_budget, if: :calculate_amount?
 
  enum paid_type: { free: "free", paid: "paid" }
  
  belongs_to :creator, class_name: "User", foreign_key: "user_id", inverse_of: :created_events
  has_one :budget, inverse_of: :event, dependent: :destroy
  has_many :payments, through: :budget
  has_and_belongs_to_many :participants, class_name: "User"
  has_and_belongs_to_many :celebrators, association_foreign_key: :celebrator_id, class_name: "User", join_table: :celebrators_events
  
  accepts_nested_attributes_for :budget

  validates :name, :description, :date, presence: true
  validates_associated :budget

  scope :unpaid, ->{ includes(budget: [:payments]).where('payments.user_id = events_users.user_id AND payments.amount < 0').references(:budget) }
  scope :should_notify, -> { where("date < ? AND date > ?", (Time.now + 5.days), Time.now) }
  scope :with_missing_payment, -> { joins(:payments).where('payments.amount < 0').uniq }
  scope :shame_notify, -> { where("date < ? AND date > ? AND paid_type = ?", (Time.now + 3.days), Time.now, "paid") }

  def select_all_participants
    self.participants = User.all - self.celebrators
  end

  def default_budget
    (budget || create_budget).tap do |b|
      b.amount = participants.inject(0) { |sum, p| sum + p.rate.amount } if paid?
      b.save
    end
  end

  def paid_payments
    payments.includes(budget: [:payments]).references(budget: [:payments]).where('payments.amount > 0')
  end

  def unpaid_payments
    payments.includes(budget: [:payments]).references(budget: [:payments]).where('payments.amount < 0')
  end

  def total_payments_amount
    paid_payments.inject(0) { |sum, p| sum + p.amount }
  end

  def balance_to_paid
    unpaid_payments.inject(0) { |sum, p| sum + p.amount }
  end

  def paid_percent
    (total_payments_amount/budget.amount)*100
  end

  def paid_participantcs_ids
    paid_payments.pluck(:user_id).uniq
  end
 
  def notify_participants ids = nil
    participants_should_be_notify = ids ? participants.find(ids) : participants
    participants_should_be_notify.each{ |participant| UserMailer.new_event_email(participant, self).deliver_now }
  end

end
