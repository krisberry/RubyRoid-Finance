require "rails_helper"

feature "admin updates user info", js: true do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let(:attributes) { { first_name: Faker::Name.first_name,
                       last_name: Faker::Name.last_name,
                       phone: Faker::PhoneNumber.cell_phone,
                       email: Faker::Internet.email,
                       description: Faker::Lorem.paragraph
                       } }

  background do
    login_user(admin)
  end

  scenario 'update user info with valid params' do
    visit  edit_admin_user_path(user)

    submit_user_form_with_valid(attributes)
    user.reload

    within '#users_table' do
      expect(page).to have_content(user.email)
    end
  end

  scenario 'update user info with invalid params' do
    visit  edit_admin_user_path(user)

    submit_user_form_with_invalid(attributes)

    expect(page.find('.user_birthday ')).to have_content("user's birthday can't be in the future")
  end
end