require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:participants_count) { 3 }
  let!(:paid_event) { FactoryGirl.create(:paid_event, :with_participants_and_payments, participants_count: participants_count) }
  
  describe "#select_all_participants" do
    it "should add all users as event participants" do
      expect(paid_event.select_all_participants).not_to be_empty
    end
  end

  describe "#update_payments" do
    let!(:new_rate) { create(:rate) }

    context 'on update event' do

      before do
        participant = paid_event.participants.first
        participant.update(rate: new_rate)
      end

      it "should update payment attributes" do
        expect { paid_event.update_payments }.to change {
          paid_event.payments.pluck(:amount)
        }
      end
    end
  end

  describe "#default_amount" do
    before do
      paid_event.default_amount
    end

    it "should create default value of event amount as sum of user's payments" do
      test_amount = paid_event.payments.inject(0) { |sum, p| sum + p.amount.abs }
      expect(paid_event.amount).to eq(test_amount)
    end
  end

  describe "#total_paid_amount" do
    it "should return sum of paid payments items" do
      test_amount = paid_event.items.inject(0) { |sum, p| sum + p.amount }
      expect(paid_event.total_paid_amount).to eq(test_amount)
    end
  end

  describe "#balance_to_pay" do
    it "should return sum of unpaid payments" do
      total_paid_amount = paid_event.total_paid_amount
      test_amount = paid_event.amount - total_paid_amount
      expect(paid_event.balance_to_pay).to eq(test_amount)
    end
  end

  describe "#paid_percent" do
    it "should return payments progress in percents" do
      test_progress = (paid_event.total_paid_amount/paid_event.amount)*100
      expect(paid_event.paid_percent).to eq(test_progress)
    end
  end

end