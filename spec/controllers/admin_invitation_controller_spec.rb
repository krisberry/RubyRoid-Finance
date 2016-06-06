require 'rails_helper'

RSpec.describe Admin::InvitationsController do
  let(:admin) { create(:admin) }
  let(:invitation) { create(:invitation) }

  before do
    sign_in(admin)
  end

  describe "GET index" do
    it "should get index" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "#create" do

    before do
      @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
    end
    
    context 'with valid params' do
      let(:params) { { email: Faker::Internet.email,
                       invited_code: Devise.friendly_token(length = 30),
                       approved: true } }


      it 'sents invitation email' do
        expect { post :create, invitation: params }.to change{ ActionMailer::Base.deliveries.count }.by(1)
      end
    end
    
    context 'when invitation already exist' do
      let(:params) { { email: invitation.email } }

      it "don't sent email with invitation" do
        expect { post :create, invitation: params }.to_not change{ ActionMailer::Base.deliveries.count }
      end

      it "raise an error" do
        post :create, invitation: params
        expect(flash[:danger]).to eq "Invitation has already been sent"
      end
    end
  end
end