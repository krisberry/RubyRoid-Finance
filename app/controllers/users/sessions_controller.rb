class Users::SessionsController < Devise::SessionsController
  before_filter :configure_sign_in_params, only: [:create]

  protected

    def configure_sign_in_params
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :provider, :uid, :birthday, :phone, image_attributes: [:photo] ) }
    end
end
