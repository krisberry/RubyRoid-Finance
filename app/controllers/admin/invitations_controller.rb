class Admin::InvitationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if User.where(email: invitation_params[:email]).present?
      flash[:danger] = "Invitation already sent"
      redirect_to :back
    else
      @user = User.new(invitation_params)
      @user.invited_code = Devise.friendly_token(length = 30)
      if @user.save(:validate => false)
        UserMailer.invitation_email(@user).deliver
      end
      redirect_to admin_root_path
    end
  end

  private

  def invitation_params
    params.require(:user).permit(:email)
  end 
end

