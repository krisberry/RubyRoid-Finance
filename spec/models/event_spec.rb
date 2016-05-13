require 'rails_helper'

RSpec.describe Budget, type: :model do
  let(:participants_count) { 3 }
  let!(:paid_event) { FactoryGirl.create(:paid_event, :with_participants_and_payments, participants_count: participants_count) }
  
  describe "#select_all_participants" do
    it "should add all users as event participants" do
      expect(paid_event.select_all_participants).not_to be_empty
    end
  end

  describe "#create_payments" do
    it "should return reverse value of amount for each payment" do
      expect(paid_event.payments.pluck(:amount)).to all( be < 0 )
    end

    context 'new' do

      subject { paid_event }

      before(:each) do
        subject.reload
      end

      it 'has one payment per participant' do
        expect(subject.payments.count).to eq(participants_count)
      end
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

  # describe "#remove_payments" do
  #   context 'when payment paid' do 

  #     before do
  #       paid_payment = paid_event.payments.first
  #       paid_payment.update(amount: paid_payment.amount.abs)
  #       paid_event.update_payments
  #     end

  #     it "should delete payment" do
  #       expect{ paid_event.remove_payments }.to change { paid_event.payments.count }.by(-1)
  #     end
  #   end
  # end  
end