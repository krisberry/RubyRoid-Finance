require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  
  describe "#full_name" do
    it "shoul return full user name" do
      test_full_name = user.first_name + " " + user.last_name
      expect(user.full_name).to eq(test_full_name)
    end
  end
end