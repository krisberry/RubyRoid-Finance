class InvitationsController < ApplicationController
  skip_before_filter :authenticate_user!
  before_action :invitation_params, only: [:create]
  
  def new
    Invitation.new
  end

  def create
    if Invitation.where(email: invitation_params[:email]).any?
      flash[:danger] = "Request has already been sent"
      redirect_to unauthenticated_root_path
    else
      @invitation = Invitation.new(invitation_params)
      if @invitation.save
        flash[:success] = "Request was successfully sent"
        redirect_to unauthenticated_root_path
      else
        flash[:danger] = "Something went wrong. Try again, please."
        redirect_to :back
      end
    end
  end

  private

    def invitation_params
      params.require(:invitation).permit(:email)
    end
end