class Budget < ActiveRecord::Base
  before_save :default_amount
  
  belongs_to :event, inverse_of: :budget
  has_many :payments, inverse_of: :budget, dependent: :destroy
  
  validates :amount, presence: true, if: :on_paid_event?
  validate :amount_cannot_be_less_than_total_paid_payments

  def on_paid_event?
    event && event.paid?
  end

  def calculate_amount?
    event.calculate_amount?
  end

  def default_amount
    self.amount = payments.inject(0) { |sum, p| sum + p.amount.abs } if event.paid?
  end

  def amount_cannot_be_less_than_total_paid_payments
    if amount && (amount < event.total_payments_amount)
      errors.add(:amount, "can't be less than total paid payments amount #{event.total_payments_amount}")
    end
  end

end
