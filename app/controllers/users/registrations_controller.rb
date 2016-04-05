class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, only: [:create, :update]

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :birthday, :phone)
    devise_parameter_sanitizer.for(:account_update).push(:first_name, :last_name, :birthday, :phone)
  end
end
