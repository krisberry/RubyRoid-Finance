require "rails_helper"

feature 'User creates an event' do
  
  before do
    @user = FactoryGirl.create(:user)
    visit  unauthenticated_root_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Login'
    # login_as(user, :scope => :user)
  end

  scenario 'they see the correctly created paid event on the page' do
    visit new_event_path

    name = Faker::Name.title
    fill_in 'Name', with: name
    fill_in 'Description', with: Faker::Lorem.paragraph
    choose 'paid'
    fill_in 'Amount', with: Faker::Number.decimal(4).to_f
    find('.input-datepicker').click
    find('td.day', text: 11).click
    select @user.full_name, from: 'Participants'

    click_button 'Save'

    expect(page).to have_content(name)
    expect(page.find('table')).to have_content('paid')
    expect(page).to have_css '.alert-success'
  end

  scenario 'they see the correctly created free event on the page' do
    visit new_event_path

    name = Faker::Name.title
    fill_in 'Name', with: name
    fill_in 'Description', with: Faker::Lorem.paragraph
    choose 'free'
    find('.input-datepicker').click
    find('td.day', text: 11).click
    select @user.full_name, from: 'Participants'

    click_button 'Save'

    expect(page).to have_content(name)
    expect(page.find('table')).to have_content('free')
    expect(page).to have_no_css('event_budget_amount')
    expect(page).to have_css '.alert-success'
  end

  scenario 'they see the correctly created paid event on the page with calculate amount and add all users' do
    visit new_event_path

    name = Faker::Name.title
    fill_in 'Name', with: name
    fill_in 'Description', with: Faker::Lorem.paragraph
    choose 'paid'
    check 'Calculate amount'
    find('.input-datepicker').click
    find('td.day', text: 11).click
    check 'Add all users'
    
    click_button 'Save'

    expect(page).to have_content(name)
    expect(page.find('table')).to have_content('paid')
    expect(page).to have_css '.alert-success'
  end

  scenario 'they see the error message on the page if validate fields is blank when event free' do
    visit new_event_path

    click_button 'Save'

    expect(page.find('.event_name')).to have_content("can't be blank")
    expect(page.find('.event_description')).to have_content("can't be blank")
    expect(page).to have_css '.alert-danger'
  end

  scenario 'they see the error message on the page if validate fields is blank when event paid' do
    visit new_event_path

    choose 'paid'

    click_button 'Save'

    expect(page.find('.event_name')).to have_content("can't be blank")
    expect(page.find('.event_description')).to have_content("can't be blank")
    expect(page.find('.event_budget_amount')).to have_content("can't be blank")
    expect(page).to have_css '.alert-danger'
  end

end