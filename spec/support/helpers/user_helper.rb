module EventHelper
  def submit_user_form_with_valid(options = {})
    shared_user_form_feilds(options)
  
    find('.input-datepicker').click
    within '.datepicker-days' do
      find('td.day:not(.new):not(.old)', text: (Date.current.day - 1), match: :prefer_exact).click
    end
    
    click_button 'Update'
  end

  def submit_user_form_with_invalid(options = {})
    shared_user_form_feilds(options)

    find('.input-datepicker').click
    within '.datepicker-days' do
      find('td.day:not(.new):not(.old)', text: (Date.current.day + 1), match: :prefer_exact).click
    end

    click_button 'Update'
  end

  def shared_user_form_feilds(options = {})
    fill_in 'First name', with: options[:first_name]
    fill_in 'Last name', with: options[:last_name]
    fill_in 'Phone', with: options[:phone]
    fill_in 'Email', with: options[:email]
    choose 'tax_collector'
  end
end