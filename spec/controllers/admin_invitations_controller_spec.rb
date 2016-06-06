require 'rails_helper'

RSpec.describe Admin::InvitationsController do
  let!(:admin)      { create(:admin) }
  let!(:invitation) { create(:invitation) }

  before do
    sign_in(admin)
    @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
  end

  describe "GET index" do
    it "should get index" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe 'GET new' do
    it 'should render new form' do
      get 'new'
      expect(response).to be_success
    end
  end

  describe "#create" do

    context 'with valid params' do
      let(:params) { { email: Faker::Internet.email,
                       invited_code: Devise.friendly_token(length = 30),
                       approved: true
                      } }


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

  describe "#destroy" do
    let(:invitation_for_delete) { create(:invitation) }

    it 'deletes the invitation' do
      delete :destroy, id: invitation_for_delete.id
      expect(flash[:success]).to eq 'Invitation deleted'
    end

    it 'sends email about invitation deleting' do
      expect{ delete :destroy, id: invitation_for_delete.id }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe "#resend" do
    let(:params) { { updated_at: Time.now } }
    let(:resend_invitation) { xhr :patch, :resend, id: invitation.id, invitation: params }

    it 'sends invitation again' do
      expect{ resend_invitation }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe "#approve_user" do
    let(:params) { { approved: true,
                     invited_code: Devise.friendly_token(length = 30)
                    } }

    it 'sends invitation again' do
      expect{ patch :approve_user, id: invitation.id, invitation: params }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end
  end

end