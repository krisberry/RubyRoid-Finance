class Admin::InvitationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(invitation_params)
    if @user.save(:validate => false)
      UserMailer.invitation_email(@user).deliver
    end
    redirect_to admin_root_path
  end

  private

  def invitation_params
    params.require(:user).permit(:email)
  end 
end
