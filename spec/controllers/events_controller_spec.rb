require 'rails_helper'

RSpec.describe EventsController do
  let(:admin)      { create(:admin) }
  let(:user)       { create(:user) }
  let!(:event)      { create(:event) }
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

  describe '#new' do
    it 'should render new form' do
      get 'new'
      expect(response).to be_success
    end
  end

  describe '#create' do
    context 'with valid params' do
      let(:params) { { name: Faker::Name.title, 
                       description: Faker::Lorem.paragraph,
                       date: Time.now + 1.day,
                       paid_type: "free",
                       calculate_amount: '1',
                       add_all_users: '1',
                       participant_ids: [],
                       celebrator_ids: [] } }

      before(:each) do
        post :create, event: params
      end

      it 'redirect to admin events index page' do
        expect(response).to redirect_to(admin_events_path)
      end

      it 'creates new event' do
        expect { post :create, event: params }.to change(Event, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:params) { { description: Faker::Lorem.paragraph,
                       date: Time.now + 1.day,
                       paid_type: "free",
                       amount: -150,
                       calculate_amount: '0',
                       add_all_users: '1',
                       participant_ids: [],
                       celebrator_ids: [] } }

      before(:each) do
        post :create, event: params
      end

      it 'render form again' do
        expect(response).to render_template('events/new')
      end
    end
  end

  describe '#edit' do
    it 'should render form' do
      get 'edit', { id: event.id }
      expect(response).to be_success
    end
  end

  describe "#update" do
    before do
      patch :update, id: event.id, event: params
      event.reload
    end

    context 'with valid params' do
      let(:params) { { name: Faker::Name.title, 
                       paid_type: "paid",
                       calculate_amount: '1',
                       add_all_users: '1',
                       participant_ids: [],
                       celebrator_ids: [] } }

      it 'redirect to admin events index page' do
        expect(response).to redirect_to(admin_events_path)
      end

      it 'updates an event' do
        expect(event.name).to eql params[:name]
        expect(flash[:success]).to eq 'Event was successfully updated'
      end
    end

    context 'with invalid params' do
      let(:params) { { paid_type: "paid",
                       calculate_amount: '0',
                       add_all_users: '1',
                       participant_ids: [],
                       celebrator_ids: [] } }

      it 'gets flash error message' do
        expect(flash[:danger]).to eq 'Some errors prohibited this event from being saved'
      end
    end
  end

  describe '#destroy' do
    context 'if current user admin' do
      it 'deletes the event' do
        delete :destroy, id: event.id
        expect(flash[:success]).to eq 'Event was successfully deleted'
      end
    end

    context 'if current user creator' do
      before do
        sign_in(paid_event.creator)
      end

      it 'deletes the event' do
        delete :destroy, id: paid_event.id
        expect(flash[:success]).to eq 'Event was successfully deleted'
      end
    end

    context 'if current user not a creator or an admin' do
      before do
        sign_in(user)
      end

      it 'gets flash error message' do
        delete :destroy, id: paid_event.id
        expect(flash[:danger]).to eq 'Only creator or admin can delete this event.'
      end
    end
  end

end