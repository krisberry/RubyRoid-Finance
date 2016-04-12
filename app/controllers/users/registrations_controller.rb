class Users::RegistrationsController < Devise::RegistrationsController
   before_filter :configure_permitted_parameters, only: [:create, :update]

  def new
    @invitation = Invitation.where(invited_code: params[:invited_code]).first
    if @invitation.present?
      session['invited_code'] = @invitation.invited_code
      build_resource({})
      self.resource.email = @invitation.email
      set_minimum_password_length
      yield resource if block_given?
      self.resource.build_image
      respond_with self.resource
    else
      flash[:danger] = 'Access denied'
      redirect_to new_user_session_path
    end
  end

  def create
    @invitation = Invitation.where(invited_code: params[:invited_code]).first
    if @invitation.present?
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        @invitation.destroy
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      flash[:danger] = 'Access denied'
      redirect_to new_user_session_path
    end
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :birthday, :phone, image_attributes: [:photo, :id])
      devise_parameter_sanitizer.for(:account_update).push(:first_name, :last_name, :birthday, :phone, image_attributes: [:photo, :id])
    end
end
