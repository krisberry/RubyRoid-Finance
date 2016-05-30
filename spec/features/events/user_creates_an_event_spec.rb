require "rails_helper"

feature 'User creates an event', js: true do
  let(:name) { Faker::Name.title }
  let(:description) { Faker::Lorem.paragraph }
  let(:user) { FactoryGirl.create(:user) }
  let(:day) { 31 }
  let(:amount) { Faker::Number.decimal(4).to_f }
  
  background do
    login_user(user)
  end

  scenario 'they see the correctly created paid event on the page' do
    visit new_event_path

    submit_paid_event_form_with(name: name, description: description, amount: amount, user_full_name: user.full_name, day: day)

    within 'table' do
      expect(page).to have_content(name)
      expect(page).to have_content('paid')
    end

    expect(page).to have_css '.alert-success'

    click_link name

    within '.hpanel.hgreen' do
      expect(page).to have_content(name)
      expect(page).to have_content(description)
      expect(page).to have_content(user.full_name)
    end
    
    expect(page).to have_css('#event-show-participants')

    within '#payments-progress' do
      expect(page.find('h3')).to have_content(amount)
    end

    within '#event-show-participants' do
      expect(page).to have_content(user.full_name)
    end

  end

  scenario 'they see the correctly created free event on the page' do
    visit new_event_path

    submit_free_event_form_with(name: name, description: description, user_full_name: user.full_name, day: day)

    within 'table' do
      expect(page).to have_content(name)
      expect(page).to have_content('free')
    end

    expect(page).to have_css '.alert-success'

    click_link name

    expect(page).to have_no_css('#payments-progress')
    expect(page).to have_no_css('#event-show-participants')

    within '.hpanel.hgreen' do
      expect(page.find('h3')).to have_content(name)
      expect(page).to have_content(description)
      expect(page).to have_content(user.full_name)
    end
  end

  scenario 'they see the correctly created paid event on the page with calculate amount and add all users' do
    visit new_event_path

    submit_paid_event_form_checked_with(name: name, description: description, amount: amount, day: day)

    expect(page).to have_content(name)
    expect(page.find('table')).to have_content('paid')

    click_link name

    within '.hpanel.hgreen' do
      expect(page.find('h3')).to have_content(name)
      expect(page).to have_content(description)
      expect(page).to have_content(user.full_name)
    end

    expect(page).to have_css('#event-show-participants')
    expect(page).to have_css('#payments-progress')

    within '#payments-progress' do
      expect(page.find('h3')).to have_content(user.rate.amount.abs)
    end

   end

  scenario 'they see the error message on the page if validate fields is blank when event free' do
    visit new_event_path

    click_button 'Save'

    expect(page.find('.event_name')).to have_content("can't be blank")
    expect(page.find('.event_description')).to have_content("can't be blank")
    expect(page.find('.event_date')).to have_content("can't be blank")
    expect(page).to have_css '.alert-danger'
  end

  scenario 'they see the error message on the page if validate fields is blank when event paid' do
    visit new_event_path

    choose 'paid'

    click_button 'Save'

    expect(page.find('.event_name')).to have_content("can't be blank")
    expect(page.find('.event_description')).to have_content("can't be blank")
    expect(page.find('.event_amount')).to have_content("can't be blank")
    expect(page.find('.event_date')).to have_content("can't be blank")
    expect(page).to have_css '.alert-danger'
  end

  scenario 'they see the correctly created custom event on the page' do
    visit new_event_path

    submit_custom_event_form_with(name: name, description: description, user_full_name: user.full_name, day: day)

    within 'table' do
      expect(page).to have_content(name)
      expect(page).to have_content('custom')
    end

    expect(page).to have_css '.alert-success'

    click_link name

    within '.hpanel.hgreen' do
      expect(page).to have_content(name)
      expect(page).to have_content(description)
      expect(page).to have_content(user.full_name)
    end
    
    expect(page).to have_css('#event-show-participants')

    within '#income-outcome' do
      start_amount = 0
      expect(page).to have_content(start_amount)
    end

    within '#event-show-participants' do
      expect(page).to have_content(user.full_name)
    end

  end

end