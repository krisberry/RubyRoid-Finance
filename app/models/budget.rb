class Budget < ActiveRecord::Base
  after_save :create_payments, :remove_payments, if: :on_paid_event?
  
  belongs_to :event, inverse_of: :budget
  has_many :payments, inverse_of: :budget, dependent: :destroy
  
  validates :amount, presence: true, if: :on_paid_event?

  def on_paid_event?
    event && event.paid?
  end

  def create_payments 
    event.participants.each do |participant|
      self.payments << participant.payments.create(amount: -1 * participant.rate.amount) unless participant.payments.for_budget(event.budget).first
    end
  end

  def remove_payments
    payments.each do |payment|
      payment.destroy unless event.participant_ids.include?(payment.user_id) || payment.amount > 0
    end
  end
end
