class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :budget
  scope :for_budget, ->(budget_id) { includes(:budget).where(budgets: {id: budget_id}) }
end
