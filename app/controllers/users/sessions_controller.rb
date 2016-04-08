class Users::SessionsController < Devise::SessionsController
  before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in

  def new
    super
  end

  # POST /resource/sign_in
  def create
    if params[:user]
      super
    elsif env["omniauth.auth"]
      self.resource = User.from_omniauth(env["omniauth.auth"])
      set_flash_message(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      redirect_to resource.admin? ? admin_root_path : root_path 
    end
  end

  # DELETE /resource/sign_out
  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :provider, :uid, :birthday, :phone, image_attributes: [:photo] ) }
  end
end
