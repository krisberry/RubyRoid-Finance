class PaymentItem < ActiveRecord::Base
  belongs_to :payment, inverse_of: :payment_items
  belongs_to :event, inverse_of: :payment_items

  def pay
    update_attribute(:amount, payments.for_event(self.event_id).first.amount)
  end
end