class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :event, inverse_of: :payments
  has_many :payment_items, dependent: :destroy
  
  scope :for_event, ->(event_id) { includes(:event).where(events: {id: event_id}).references(:events) }
  scope :unpaid, -> { where("payments.amount < 0") }
  # scope :unpaid, -> { joins(:payment_items).where('payment_items.amount = 0') }
  scope :paid, -> { where("payments.amount > 0") }
  scope :for_user, ->(user_id) { includes(:user).where(users: {id: user_id}).references(:users).first }
  
  def pay
    update_attribute(:amount, amount * -1)
  end

  def paid?
    amount > 0
  end  
end
