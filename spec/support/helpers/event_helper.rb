module EventHelper
  def submit_paid_event_form_with(options = {})
    choose 'paid'
    shared_event_form_fields(options)
    fill_in 'Amount', with: options[:amount]
    check 'Add all users'
    
    click_button 'Save'
  end

  def submit_free_event_form_with(options = {})
    choose 'free'
    shared_event_form_fields(options)
    check 'Add all users'

    click_button 'Save'
  end

  def submit_paid_event_form_checked_with(options = {})
    choose 'paid'
    shared_event_form_fields(options)
    fill_in 'Amount', with: options[:amount]
    check 'Calculate amount'
    check 'Add all users'
    
    click_button 'Save'
  end

  def submit_custom_event_form_with(options = {})
    choose 'custom'
    shared_event_form_fields(options)
    check 'Add all users'

    click_button 'Save'
  end

  def update_event_from_free_to_paid_with(options = {})
    choose 'paid'
    shared_event_form_fields(options)
    check 'Calculate amount'
    check 'Add all users'
  end

  def update_event_from_paid_to_free_with(options = {})
    choose 'free'
    shared_event_form_fields(options)
    check 'Add all users'
  end

  def update_event_from_paid_to_custom_with(options = {})
    choose 'custom'
    shared_event_form_fields(options)
    check 'Add all users'
  end

  private

  def shared_event_form_fields(options = {})
    fill_in 'Name', with: options[:name]
    fill_in 'Description', with: options[:description]
    find('.input-datepicker').click
    within '.datepicker-days' do
      find('td.day:not(.new):not(.old)', text: options[:day], match: :prefer_exact).click
    end
  end

end