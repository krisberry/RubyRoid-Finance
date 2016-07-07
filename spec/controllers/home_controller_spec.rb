require 'rails_helper'

RSpec.describe HomeController do

  describe '#index' do
    let(:user) { create(:user) }

    context 'when user is authenticated' do
      it 'gets index' do
        sign_in(user)

        get 'index'
        expect(response).to render_template('index')
      end
    end

  end

end