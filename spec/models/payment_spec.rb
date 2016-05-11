require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:payment) { FactoryGirl.create(:payment) }
  
  describe "#pay" do
    it "should return true if updated attribute is reverse value of amount" do
      payment.amount *= (-1)
      expect(payment.pay).to be true
    end
  end

  describe "#paid?" do
    it "should return true if user had pay" do
      expect(payment.paid?).to be true
    end

    it "should return false if hadn't user " do
      payment.amount *= (-1)
      expect(payment.paid?).to be false
    end
  end
end