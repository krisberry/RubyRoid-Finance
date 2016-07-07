require 'rails_helper'

RSpec.describe Admin::EventsController do
  let(:admin)      { create(:admin) }
  let(:user)       { create(:user) }
  let!(:event)     { create(:event) }
  let(:paid_event) { create(:paid_event) }

  before do
    sign_in(admin)
    @request.env['HTTP_REFERER'] = 'http://localhost'
  end

  describe '#index' do
    it 'should get index' do
      get 'index'
      expect(response).to render_template("index")
    end

    it 'assigns @events' do
      get 'index'
      expect(Event.all).to eq([event])
    end
  end

  describe '#show' do
    it 'should get show page' do
      get 'show', { id: event.id }
      expect(response).to render_template('show')
    end
  end

  describe '#edit' do
    it 'should render form' do
      get 'edit', { id: event.id }
      expect(response).to be_success
    end
  end

  describe '#destroy' do
    context 'if current user admin' do
      it 'deletes the event' do
        delete :destroy, id: event.id
        expect(flash[:success]).to eq 'Event deleted'
      end
    end
  end

end