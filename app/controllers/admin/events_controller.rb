class Admin::EventsController < ApplicationController
  before_filter :admin_only

  def index
    @events = if params[:user_id]
      User.find(params[:user_id]).events.unpaid
    elsif params[:creator_id]
      User.find(params[:creator_id]).created_events
    else
      Event.all
    end
  end

  def show
    @event = Event.find(params[:id])
    @payment = current_user.payments.for_budget(@event.budget).first
  end

  def edit
    @event = Event.find(params[:id])
    render :edit
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:success] = 'Event was successfully updated'
      redirect_to :back
    else
      flash[:danger] = "Some errors prohibited this event from being saved"
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id]).destroy
    flash[:success] = 'Event deleted'
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

    def event_params
      params.require(:event).permit(:name, :date, :description, :price, :paid_type, :add_all_users, :calculate_amount, budget_attributes: [:amount], participant_ids: [])
    end
end
