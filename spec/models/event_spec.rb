require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:participants_count) { 3 }
  let!(:paid_event) { create(:paid_event, :with_participants_and_payments, participants_count: participants_count) }
  let(:event) { create(:event) }
  let(:custom_event) { create(:custom_event) }
  
  describe "#should_validate_date?" do
    it "should return true if event not custom" do
      expect(paid_event.should_validate_date?).to be true
      expect(event.should_validate_date?).to be true
    end

    it "should return false if event custom" do
      expect(custom_event.should_validate_date?).to be false
    end
  end

  describe "#create_null_amounts" do

    context "on custom event" do
      before do
        custom_event.create_null_amounts
      end

      it "should create event and payments amount with value of 0 " do
        expect(custom_event.amount).to eq(0)
        expect(custom_event.payments.first.amount).to eq(0)
      end
    end
  end

  describe "#total" do
    it "should calculate sum of items" do
      test_total = paid_event.items.sum(:amount)
      expect(paid_event.total).to eq(test_total)
    end
  end

  describe "#not_calculate_amount?" do
    it "should return true if calculate amount not checked" do
      paid_event.calculate_amount = false
      expect(paid_event.not_calculate_amount?).to be true
    end

    it "should return false if calculate amount checked" do
      expect(paid_event.not_calculate_amount?).to be false
    end
  end

  describe "#validate_amount?" do
    it "should return true if event paid and calculate amount not checked" do
      paid_event.calculate_amount = false
      expect(paid_event.validate_amount?).to be true
    end

    it "should return false if event not paid" do
      expect(custom_event.validate_amount?).to be false
      expect(event.validate_amount?).to be false
    end
  end

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

  describe "#paid_participants_ids" do

    it "should return uniq vlaue of users id" do
      test_ids = paid_event.items.pluck(:user_id).uniq
      expect(paid_event.paid_participants_ids).to eq(test_ids)
    end
  end

end