class Event < ActiveRecord::Base
  before_save :select_all_participants, if: :add_all_users?
  before_create :create_payments, if: :paid?
  before_update :update_payments, if: :paid?
  before_save :remove_payments, if: :paid?
 
  enum paid_type: { free: "free", paid: "paid" }
  
  belongs_to :creator, class_name: "User", foreign_key: "user_id", inverse_of: :created_events
  has_many :payments, dependent: :destroy
  has_many :payment_items, dependent: :destroy
  has_and_belongs_to_many :participants, class_name: "User"
  has_and_belongs_to_many :celebrators, association_foreign_key: :celebrator_id, class_name: "User", join_table: :celebrators_events
  
  validates :name, :description, :date, presence: true
  validates :amount, presence: true, if: :validate_amount?
  validate :amount_cannot_be_less_than_total_paid_payments

  scope :unpaid, ->{ includes(:payments).where('payments.user_id = events_users.user_id AND payments.amount < 0').references(:payments) }
  scope :should_notify, -> { where("date < ? AND date > ?", (Time.now + 5.days), Time.now) }
  scope :with_missing_payment, -> { joins(:payments).where('payments.amount < 0').uniq }
  scope :shame_notify, -> { where("date < ? AND date > ? AND paid_type = ?", (Time.now + 3.days), Time.now, "paid") }

  def not_calculate_amount?
    !calculate_amount?
  end

  def validate_amount?
    paid? && not_calculate_amount?
  end

  def select_all_participants
    self.participants = User.all - self.celebrators
  end

  def create_payments
    if calculate_amount?
      participants.each do |participant|
        self.payments << participant.payments.create(amount: -participant.rate.amount)
        # participant.payments.create(amount: -participant.rate.amount)
      end
      default_amount
    else
      payment = amount/participants.size
      participants.each do |participant|
        self.payments << participant.payments.create(amount: -payment.round(2))
        # participant.payments.create(amount: -payment.round(2))
      end
    end
  end

  def update_payments
    create_payments if amount == nil
    if calculate_amount?
      unpaid_payments.each do |payment|
        payment.update_attributes(amount: -payment.user.rate.amount) 
      end
      default_amount
    else
      unpaid_amount = self.amount - total_payments_amount
      new_amount = unpaid_amount/unpaid_payments.size
      unpaid_payments.each do |payment|
        payment.update_attributes(amount: -new_amount.round(2))
      end
    end
  end

  def remove_payments
    payments.each do |payment|
      payment.destroy unless participant_ids.include?(payment.user_id) || payment.amount > 0
    end
  end 

  def default_amount
    self.amount = payments.inject(0) { |sum, p| sum + p.amount.abs } if paid?
  end

  def unpaid_payments
    payments.unpaid
  end

  def total_payments_amount
    # payment_items.inject(0) { |sum, pi| sum + pi.amount }
    payments.paid.inject(0) { |sum, p| sum + p.amount }
  end

  def balance_to_paid
    payments.unpaid.inject(0) { |sum, p| sum + p.amount }
    # amount - total_payments_amount
  end

  def paid_percent
    (total_payments_amount/amount)*100
  end

  def paid_participants_ids
    payments.paid.pluck(:user_id).uniq
  end
 
  def notify_participants ids = nil
    participants_should_be_notify = ids ? participants.find(ids) : participants
    participants_should_be_notify.each{ |participant| UserMailer.new_event_email(participant, self).deliver_now }
  end

  def amount_cannot_be_less_than_total_paid_payments
    if amount && (amount < total_payments_amount)
      errors.add(:amount, "can't be less than total paid payments amount #{total_payments_amount}")
    end
  end

end
