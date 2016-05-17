module EventHelper
  def submit_paid_event_form_with(options = {})
    shared_event_form_fields(options)
    choose 'paid'
    fill_in 'Amount', with: options[:amount]
    select options[:user_full_name], from: 'Participants'

    click_button 'Save'
  end

  def submit_free_event_form_with(options = {})
    shared_event_form_fields(options)
    choose 'free'
    select user.full_name, from: 'Participants'

    click_button 'Save'
  end

  def submit_paid_event_form_checked_with(options = {})
    shared_event_form_fields(options)
    choose 'paid'
    fill_in 'Amount', with: options[:amount]
    check 'Calculate amount'
    check 'Add all users'
    
    click_button 'Save'
  end

  def update_event_from_free_to_paid_with(options = {})
    shared_event_form_fields(options)
    choose 'paid'
    check 'Calculate amount'
    select options[:user_full_name], from: 'Participants'
  end

  private

  def shared_event_form_fields(options = {})
    fill_in 'Name', with: options[:name]
    fill_in 'Description', with: options[:description]
    find('.input-datepicker').click
    within '.datepicker-days' do
      find('td.day', text: options[:day]).click
    end
  end

end