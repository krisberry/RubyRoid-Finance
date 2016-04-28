require 'rails_helper'

RSpec.describe Budget, type: :model do
  let(:event) { FactoryGirl.create(:event) }
  let(:budget) { FactoryGirl.create(:budget, event: event) }
  
  describe "#on_paid_event?" do
    it "should return true if event has paid type" do
      budget.event.paid_type = "paid"
      expect(budget.on_paid_event?).to be true
    end

    it "should return false if event has free type" do
      expect(budget.on_paid_event?).to be false
    end    
  end

  describe "#create_payments" do
    before do
      3.times { event.participants << FactoryGirl.create(:user) }
      budget.create_payments 
    end

    it "should return 3 payments because event has 3 participants" do
      expect(budget.payments.count).to eq(3)
    end
    
    it "should return reverse value of amount for each payment" do
      expect(budget.payments.pluck(:amount)).to all( be < 0)
    end
  end
end