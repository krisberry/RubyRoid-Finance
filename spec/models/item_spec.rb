require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:paid_event) { create(:paid_event, :with_participants_and_payments) }
  let(:custom_event) { create(:custom_event) }
  let(:item) { create(:item, event_id: paid_event.id, payment_id: paid_event.payments.first.id) }
  let(:custom_item) { create(:item, event_id: custom_event.id, payment_id: custom_event.payments.first.id) }
  let(:credit_item) { create(:credit_item, event_id: custom_event.id, payment_id: custom_event.payments.first.id) }

  describe "#should_update_amount?" do
    it "should return true if custom event" do
      expect(custom_item.should_update_amount?).to be true
    end

    it "should return false if event free or paid" do
      expect(item.should_update_amount?).to be false
      expect(item.should_update_amount?).to be false
    end
  end

  describe "#update_event_amount_and_payment" do
    before do
      custom_item.update_event_amount_and_payment
    end

    it "should update event amount" do
      test_amount = custom_event.credit_items.sum(:amount) - custom_event.credit_items.sum(:amount)
      expect(custom_event.amount).to eq(test_amount)
    end

    it "should update pauyments amount" do
      payment = custom_event.payments.first
      test_amount = payment.items.sum(:amount)
      expect(payment.amount).to eq(test_amount)
    end
  end
end