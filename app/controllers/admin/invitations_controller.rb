class Admin::InvitationsController < ApplicationController
  before_filter :admin_only
  before_action :invitation_params, only: [:create]
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
        UserMailer.invitation_email(@invitation).deliver_now
      end
      flash[:success] = "Invitation was successfully sent"
      redirect_to :back
    end
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    UserMailer.deleting_invitation_email(@invitation).deliver_now
    @invitation.destroy
    flash[:success] = 'Invitation deleted'
    redirect_to :back
  end

  def update
    @invitation = Invitation.find(params[:id])
    if @invitation.update(updated_at: Time.now)
      UserMailer.invitation_email(@invitation).deliver
    end
    respond_to do |format|
      format.html
      format.js { flash[:success] = "Invitation was successfully sent" }
    end
  end

  private

    def invitation_params
      params.require(:invitation).permit(:email)
    end

  protected

    def sortable_columns
      super.push("email", "updated_at")
    end 
end

