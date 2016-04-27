require 'rails_helper'

RSpec.describe Invitation, type: :model do
  let(:invitation) { FactoryGirl.create(:invitation) }
  
  describe "#expired" do
    it "should return date of invitation's expiration" do
      expiration_date = invitation.updated_at + 2.days
      expect(invitation.expired).to eq(expiration_date)
    end
  end

  describe "#will_expired?" do
    it "return true if invitation is approved and will and expired in next 12 hours" do
      invitation.approved = true
      invitation.updated_at = "2016-04-25 18:30:00"
      expect(invitation.will_expired?).to be true 
    end

    it "return false if invitation will not be expired in next 12 hours" do
      invitation.approved = true
      invitation.updated_at = "2016-04-26 12:30:00"
      expect(invitation.will_expired?).to be false 
    end

    it "should return false if invitation not approved" do
      invitation.approved = false
      invitation.updated_at = "2016-04-25 18:30:00"
      expect(invitation.will_expired?).to be false
    end
  end
end
