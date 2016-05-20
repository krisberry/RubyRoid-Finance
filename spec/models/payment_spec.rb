require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:payment) { FactoryGirl.create(:payment) }
  
  describe "#balance_to_pay_per_user" do
    it "should return balance to pey for each user" do
      test_balance = payment.amount - payment.items.sum(:amount)
      expect(payment.balance_to_pay_per_user).to eq(test_balance)
    end
  end  
end