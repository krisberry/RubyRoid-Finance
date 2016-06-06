require 'rails_helper'

RSpec.describe EventsController do
  let(:admin) { create(:admin) }
  let(:event) { create(:event) }

  before do
    sign_in(admin)
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
      end
    end
  end

end