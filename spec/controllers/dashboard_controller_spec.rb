require 'rails_helper'

RSpec.describe DashboardController do
  let(:user) { create(:user_with_events) }

  before do
    sign_in(user)
  end

  describe '#index' do
    it 'gets index' do
      get 'index'
      expect(response).to render_template('index')
    end
  end

  describe '#calendar' do
    before(:each) { get 'calendar' }
    
    it 'gets calendar' do
      expect(response).to render_template('calendar')
    end
    
    it 'assigns @events' do
      events = user.events
      expect(assigns(:events)).to match_array events
    end
  end

end