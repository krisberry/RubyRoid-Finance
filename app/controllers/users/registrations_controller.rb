class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, only: [:create, :update]

  def new
    build_resource({})
    set_minimum_password_length
    yield resource if block_given?
    self.resource.build_image
    respond_with self.resource
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :birthday, :phone, :invited_code, image_attributes: [:photo] )
    devise_parameter_sanitizer.for(:account_update).push(:first_name, :last_name, :birthday, :phone, :avatar, :invited_code, image_attributes: [:photo])
  end
end
