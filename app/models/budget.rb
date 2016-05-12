class Budget < ActiveRecord::Base
  after_create :create_payments, if: :on_paid_event?
  after_update :update_payments, if: :on_paid_event?
  after_save :remove_payments, if: :on_paid_event?
  
  belongs_to :event, inverse_of: :budget
  has_many :payments, inverse_of: :budget, dependent: :destroy
  
  validates :amount, presence: true, if: :on_paid_event?

  def on_paid_event?
    event && event.paid?
  end

  def create_payments 
    if event.calculate_amount?
      event.participants.each do |participant|
        self.payments << participant.payments.create(amount: -1 * participant.rate.amount)
      end
    else
      payment = self.amount/event.participants.size
      event.participants.each do |participant|
        self.payments << participant.payments.create(amount: -1 * payment)
      end
    end
  end 

  def update_payments
    if event.calculate_amount?
      event.participants.each do |participant|
        participant.payments.unpaid_for_budget(self.id).last.update_attributes(amount: -1 * participant.rate.amount)
      end
    else
      not_paid_participants = event.participants.not_paid
      unpaid_amount = self.amount - event.total_payments_amount
      payment = unpaid_amount/event.not_paid_participants.size
      event.participants.each do |participant|
        participant.payments.unpaid_for_budget(self.id).last.update_attributes(amount: -1 * payment.round(2))
      end
    end
  end

  def remove_payments
    payments.each do |payment|
      payment.destroy unless event.participant_ids.include?(payment.user_id) || payment.amount > 0
    end
  end
end
