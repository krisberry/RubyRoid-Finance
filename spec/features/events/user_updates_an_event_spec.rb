require "rails_helper"

feature "user updates an event", js: true do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:event) { FactoryGirl.create(:event, creator: user ) }
  let!(:paid_event) { FactoryGirl.create(:paid_event, creator: user) }
  let(:day) { Date.current.day }
  let(:attributes) { { name: Faker::Name.title, description: Faker::Lorem.paragraph, amount: Faker::Number.decimal(4).to_f, day: day } }

  background do
    login_user(user)
  end

  scenario 'update event from free to paid as creator' do
    visit edit_event_path(event)

    update_event_from_free_to_paid_with(attributes)

    expect(page.find('form')).to have_css('.event_amount')

    click_button 'Save'

    click_link attributes[:name]

    within '#payments-progress' do
      expect(page.find('h3')).to have_content(user.rate.amount.abs)
    end

  end

  scenario 'update event from paid to free as creator' do
    visit edit_event_path(paid_event)

    update_event_from_paid_to_free_with(attributes)

    # expect(page.find('form')).to have_no_css('.event_amount')

    click_button 'Save'
    click_link attributes[:name]

    expect(page).to have_no_css('#payments-progress')
  end

  scenario 'update event from paid to custom as creator' do
    visit edit_event_path(paid_event)

    update_event_from_paid_to_custom_with(attributes)

    click_button 'Save'

    click_link attributes[:name]

    expect(page).to have_content("All Income")
    expect(page).to have_no_content("Balance to pay")
  end
end