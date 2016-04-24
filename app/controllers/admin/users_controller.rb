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

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = 'User was successfully deleted'
    redirect_to :back    
  end

  protected

    def sortable_columns
      super.push("email", "birthday", "first_name", "last_name")
    end 
end
