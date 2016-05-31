class Rate < ActiveRecord::Base
  has_many :users

  validates :amount, presence: true, numericality: { greater_than: 0 }
end
