class Item < ActiveRecord::Base
  after_create :update_event_amount_and_payment, if: :should_update_amount?

  belongs_to :payment, inverse_of: :items
  belongs_to :event, inverse_of: :items
  belongs_to :user, foreign_key: "created_by"

  def should_update_amount?
    event && event.custom?
  end

  def update_event_amount_and_payment
    payment.update_attribute(:amount, payment.items.sum(:amount)) if payment.present?
    event.update_attribute(:amount, event.items.sum(:amount) - event.credit_items.sum(:amount))
  end
end