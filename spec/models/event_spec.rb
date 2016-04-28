require 'rails_helper'

RSpec.describe Budget, type: :model do
  let(:event) { FactoryGirl.create(:event) }
  
  describe "#select_all_participants" do
    it "should add all users as event participants" do
      expect(event.select_all_participants).not_to be_empty
    end
  end

  describe "#default_budget" do
    before do
      3.times { event.participants << FactoryGirl.create(:user) }
      event.default_budget
    end

    it "should create budget if budget doesn't exist" do
      expect(event.budget.persisted?).to be_truthy
    end

    it "should create default value of budget as sum of user's money rates" do
      test_amount = event.participants.inject(0) { |sum, p| sum + p.money_rate }
      expect(event.budget.amount).to eq(test_amount)
    end
  end
end