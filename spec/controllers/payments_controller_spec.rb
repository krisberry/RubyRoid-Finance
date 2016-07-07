require 'rails_helper'

RSpec.describe PaymentsController do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe '#index' do
    it 'gets index' do
      get 'index'
      expect(response).to render_template('index')
    end
  end
end