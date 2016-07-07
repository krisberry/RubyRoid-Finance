require 'rails_helper'

RSpec.describe Admin::UsersController do
  let!(:admin) { create(:admin) }
  let(:user)   { create(:user) }

  before do
    sign_in(admin)
    @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
  end

  describe '#index' do
    it 'should get index' do
      get 'index'
      expect(response).to be_success
    end
  end

  describe '#show' do
    it 'should get show' do
      get 'show', { id: user.id }
      expect(response).to render_template('show')
    end
  end

  describe '#edit' do
    it 'should get edit' do
      get 'edit', { id: user.id }
      expect(response).to render_template('edit')
    end
  end

  describe "#update" do
    before do
      patch :update, id: user.id, user: params
      user.reload
    end

    context 'with valid params' do
      let(:params) { { email: Faker::Internet.email, 
                       birthday: Faker::Time.between(DateTime.now - 50.years, DateTime.now),
                       first_name: Faker::Name.first_name,
                       last_name: Faker::Name.last_name,
                       role: '1' } }

      it 'redirect to admin users index page' do
        expect(response).to redirect_to(admin_users_path)
      end

      it 'updates user' do
        expect(user.first_name).to eql params[:first_name]
        expect(flash[:success]).to eq 'User info was successfully updated'
      end
    end

    context 'with invalid params' do
      let(:params) { { email: nil, 
                       birthday: DateTime.now + 50.years,
                       first_name: Faker::Name.first_name,
                       last_name: Faker::Name.last_name,
                       role: '2' } }

      it 'gets flash error message' do
        expect(flash[:danger]).to eq 'Some errors prohibited this user from being saved'
      end
    end
  end

  describe '#destroy' do
    it 'deletes the user' do
      delete :destroy, id: user.id
      expect(flash[:success]).to eq 'User was successfully deleted'
    end
  end

end