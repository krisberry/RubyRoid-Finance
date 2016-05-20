class Payment < ActiveRecord::Base
  belongs_to :participant, class_name: "User", foreign_key: "user_id"
  belongs_to :event, inverse_of: :payments
  has_many :items, dependent: :destroy
  
  scope :for_user, ->(user_id) { includes(:participant).where(users: {id: user_id}).references(:participants).first }

  def balance_to_pay_per_user
    self.amount - self.items.sum(:amount)
  end

  def overpay
    "OVERPAY " + "#{balance_to_pay_per_user.abs}" if balance_to_pay_per_user < 0
  end
end
