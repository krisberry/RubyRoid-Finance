require 'rails_helper'

RSpec.describe Admin::InvitationsController do
  let(:admin) { create(:admin) }

  before do
    sign_in(admin)
  end

  describe '#new' do
    it 'gets new' do
      get 'new'
      expect(response).to render_template('new')
    end
  end
end
