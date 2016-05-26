require "rails_helper"

feature 'Admin go to show user page' do
  let(:admin) { FactoryGirl.create(:admin) }
    
  background do
    login_user(admin)
    @user = FactoryGirl.create(:user_with_events)
  end

  scenario 'see the correct user info' do
    visit admin_users_path

    expect(page).to have_content(@user.full_name)
    expect(page).to have_content(@user.email)
    expect(page).to have_content(@user.image)

    click_link @user.full_name

    within '.hpanel.hgreen' do
      expect(page).to have_content(@user.full_name)
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@user.rate.name)
    end

    expect(page).to have_content("Events created by #{@user.full_name}")
    expect(page).to have_content("Unpaid events")

    within '#unpaid-events' do
      expect(page).to have_css('.glyphicon.glyphicon-circle-arrow-down')
      expect(page).to have_css('.glyphicon.glyphicon-eye-open')
      expect(page).to have_css('.glyphicon.glyphicon-pencil')
      expect(page).to have_css('.glyphicon.glyphicon-trash')
    end

  end

end