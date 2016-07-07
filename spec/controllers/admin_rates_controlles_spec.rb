require 'rails_helper'

RSpec.describe Admin::RatesController do
  let(:admin) { create(:admin) }
  let(:user)  { create(:user) }
  let(:rate)  { create(:rate) }
  
  before do
    sign_in(admin)
  end

  describe '#edit' do
    
    context 'when current user is admin' do
      it 'should render form' do
        get 'edit', { id: rate.id }
        expect(response).to be_success
      end
    end

    context 'when current user is simple user' do
      before(:each) { sign_in(user) }
      subject { get 'edit', { id: rate.id } }
      
      it 'should render form' do
        expect(subject).to redirect_to(authenticated_root_path) 
      end
    end
  end

end