require 'rails_helper'

RSpec.describe InvitationsController do
  let!(:user)               { create(:user) }
  let!(:invitation_request) { create(:invitation_request) }

  describe '#new' do
    it 'should render new form' do
      get 'new'
      expect(response).to be_success
    end
  end

  describe '#create' do

    context 'when user create request for invitation with valid params' do
      let(:params) { { email: Faker::Internet.email } }

      it 'creates not approved invitation' do
        expect{ post :create, invitation: params }.to change {Invitation.count}.by(1)
      end
    end

    context 'when user already sent request for invitation' do
      let(:params) { { email: invitation_request.email } }

      it 'returns flash error message' do
        post :create, invitation: params
        expect(flash[:danger]).to eq 'Request has already been sent'
      end
    end

    context 'when user create request for invitation with invalid params' do
      let(:params) { { email: 12345678 } }
      
      before do
        @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
      end

      it 'returns flash error' do
        post :create, invitation: params
        expect(flash[:danger]).to eq 'Something went wrong. Try again, please.'
      end
    end
  end

end