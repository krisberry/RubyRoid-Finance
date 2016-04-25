class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth_log_in(request.env["omniauth.auth"])

    if @user
      sign_in_with_facebook
    else
      @invitation = Invitation.where(invited_code: session["invited_code"]).first
      if @invitation.present?
        @user = User.from_omniauth_sign_up(request.env["omniauth.auth"])
        UserMailer.send_password(@user).deliver_now
        @invitation.destroy
        sign_in_with_facebook
      else
        flash[:danger] = 'You can not registrate on this site. Ask admin to invite you, please.'
        redirect_to new_user_session_path
      end
    end
  end

  def failure
    redirect_to root_path
  end

  private
    def sign_in_with_facebook
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      sign_in_and_redirect @user, :event => :authentication
    end
end