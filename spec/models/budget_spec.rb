require 'rails_helper'

RSpec.describe Budget, type: :model do
  let!(:event) { FactoryGirl.create(:paid_event, :with_participants_and_payments, participants_count: 3) }
  let!(:budget) { event.budget }

  describe "#on_paid_event?" do
    it "should return true if event has paid type" do
      expect(budget.on_paid_event?).to be true
    end

    it "should return false if event has free type" do
      budget.event.paid_type = "free"
      expect(budget.on_paid_event?).to be false
    end    
  end

  describe "#calculate_amount?" do
    it "should return true if checked calculate amount" do
      expect(budget.calculate_amount?).to be true
    end

    it "should return false if unchecked calculate amount" do
      event.calculate_amount = "0"
      expect(budget.calculate_amount?).to be false
    end
  end

  describe "#default_amount" do
    before do
      budget.default_amount
    end

    it "should create budget if budget doesn't exist" do
      expect(budget.persisted?).to be_truthy
    end

    it "should create default value of budget as sum of user's payments" do
      test_amount = budget.payments.inject(0) { |sum, p| sum + p.amount.abs }
      expect(budget.amount).to eq(test_amount)
    end
  end

end