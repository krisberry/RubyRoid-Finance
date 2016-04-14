class Budget < ActiveRecord::Base
  after_create :create_payments, if: :on_paid_event?
  belongs_to :event, inverse_of: :budget
  has_many :payments, autosave: true
  validates :amount, presence: true, if: :on_paid_event?

  def on_paid_event?
    event && event.paid?
  end

  def create_payments 
    event.participants.each do |participant|
      self.payments << participant.payments.create(amount: participant.money_rate)
    end
  end
end
