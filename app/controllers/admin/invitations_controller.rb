class Admin::InvitationsController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    @invitations = Invitation.order(order_query)
  end  

  def new
    @invitation = Invitation.new
  end

  def create
    if Invitation.where(email: invitation_params[:email]).present?
      flash[:danger] = "Invitation already sent"
      redirect_to :back
    else
      @invitation = Invitation.new(invitation_params)
      @invitation.invited_code = Devise.friendly_token(length = 30)
      if @invitation.save
        UserMailer.invitation_email(@invitation).deliver
      end
      flash[:success] = "Invitation was successfully sent"
      redirect_to :back
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end 
end

