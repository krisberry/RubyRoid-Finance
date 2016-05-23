class Event < ActiveRecord::Base
  before_save :select_all_participants, if: :add_all_users?
  before_save :update_payments, if: :paid?
  before_save :remove_payments, if: :paid?
  before_create :create_null_amounts, if: :custom?

  enum paid_type: { free: "free", paid: "paid", custom: "custom" }
  
  belongs_to :creator, class_name: "User", foreign_key: "user_id", inverse_of: :created_events
  has_many :participants, through: :payments
  has_many :payments, dependent: :destroy
  has_many :items, through: :payments

  has_and_belongs_to_many :celebrators, association_foreign_key: :celebrator_id, class_name: "User", join_table: :celebrators_events
  
  validates :name, :description, :date, presence: true
  validates :amount, presence: true, if: :validate_amount?
  validate :amount_cannot_be_less_than_total_paid_amount
  validate :event_date_cannot_be_in_the_past

  scope :should_notify, -> { where("date < ? AND date > ?", (Time.now + 5.days), Time.now) }
  scope :shame_notify, -> { where("date < ? AND date > ? AND paid_type = ?", (Time.now + 3.days), Time.now, "paid") }

  def create_null_amounts
    self.amount = 0
    self.payments.any? ? payments.update_all(amount: 0) : payments.create(amount: 0)
  end

  def total
    self.items.sum(:amount)
  end

  def not_calculate_amount?
    !calculate_amount?
  end

  def validate_amount?
    paid? && not_calculate_amount?
  end

  def select_all_participants
    self.participants = User.all - self.celebrators
  end

  def update_payments
    if calculate_amount?
      payments.each do |payment|
        payment.update_attributes(amount: payment.participant.rate.amount) 
      end
      default_amount
    else
      new_amount = self.amount/payments.size
      payments.each do |payment|
        payment.update_attributes(amount: new_amount.round(2))
      end
    end
  end

  def remove_payments
    payments.each do |payment|
      payment.destroy unless participant_ids.include?(payment.user_id) || payment.items.sum(:amount) > 0
    end
  end 

  def default_amount
    self.amount = payments.inject(0) { |sum, p| sum + p.amount.abs } if paid?
  end

  def total_paid_amount
    items.inject(0) { |sum, i| sum + i.amount }
  end

  def balance_to_pay
    amount - total_paid_amount
  end

  def paid_percent
    (total_paid_amount/amount)*100
  end

  def paid_participants_ids
    items.pluck(:user_id).uniq
  end
 
  def notify_participants ids = nil
    participants_should_be_notify = ids ? participants.find(ids) : participants
    participants_should_be_notify.each{ |participant| UserMailer.new_event_email(participant, self).deliver_now }
  end

  def amount_cannot_be_less_than_total_paid_amount
    errors.add(:amount, "can't be less than total paid payments amount #{total_payments_amount}") if amount && (amount < total_paid_amount)
  end

  def event_date_cannot_be_in_the_past
    errors.add(:date, "event can't be created in the past") if (date && date < Time.now)
  end

end
