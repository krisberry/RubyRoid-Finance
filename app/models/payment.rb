class Payment < ActiveRecord::Base

  belongs_to :event
  belongs_to :participant, class_name: 'User'

  # belongs_to :budget, inverse_of: :payments
  
  scope :for_budget, ->(budget_id) { includes(:budget).where(budgets: {id: budget_id}) }
  scope :unpaid, -> { where("amount < 0") }
  scope :for_user, ->(user_id) { includes(:user).where(users: {id: user_id}).references(:users).first }

  def pay
    update_attribute(:amount, amount * -1)
  end
end
