require "rails_helper"

feature 'User creates an event', js: true do
  let(:admin) { create(:admin) }

  background do
    login_user(admin)
    @user = FactoryGirl.create(:user_with_events)
  end

  scenario 'see the correct user info' do
    visit admin_root_path

    expect(page).to have_css('#calendar')

    within '#calendar' do
      expect(page.find("#month")).to have_content(Time.now.strftime("%B %Y"))
      expect(page).to have_css('li')
    end

    expect(page).to have_css('#without-date')
    test_event = @user.created_events.where('date IS NULL').first.name
    expect(page.find('#without-date')).to have_content(test_event)
  end
end
