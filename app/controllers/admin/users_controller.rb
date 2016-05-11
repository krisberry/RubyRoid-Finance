class Admin::UsersController < ApplicationController
  before_filter :admin_only
  def index
    @users = User.order(order_query)
  end

  def show
    @user = User.find(params[:id])
    @unpaid_events = @user.events.unpaid.limit(5)
    @created_events = @user.created_events.limit(5)
  end

  def edit
    @user = User.find(params[:id])
    render :edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'User info was successfully updated'
      redirect_to admin_users_path
    else
      flash[:danger] = "Some errors prohibited this user from being saved"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = 'User was successfully deleted'
    redirect_to :back    
  end

  def pay_for_event
    @payment = Payment.find(params[:id])
    respond_to do |format|
      if @payment.pay
        format.js { flash[:success] = 'Successfully paid' }
      else
        format.js { flash[:danger] = 'Try again' }
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :birthday, :phone, :rate_id, image_attributes: [:photo, :id])
    end

  protected

    def sortable_columns
      super.push("email", "birthday", "first_name", "last_name")
    end 
end
