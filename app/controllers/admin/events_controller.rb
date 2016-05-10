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
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @event = Event.find(params[:id])
    render :edit
  end

  def update
    params[:event].delete_if{ |key, value| ["calculate_amount", "budget_attributes"].include?(key)} if event_params[:paid_type] == "free"
    params[:event].delete(:budget_attributes) if event_params[:calculate_amount] == "1"
    @event = Event.find(params[:id])
    @old_participant_ids = @event.participant_ids
    if @event.update(event_params)
      @not_notify = (@event.participant_ids & @old_participant_ids.map(&:to_i)) | @event.celebrator_ids
      @event.participants.each do |participant|
        UserMailer.new_event_email(participant, @event).deliver_now unless @not_notify.include?(participant.id)
      end
      flash[:success] = 'Event was successfully updated'
      redirect_to admin_events_path
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
    @event = @payment.budget.event
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
      params.require(:event).permit(:name, :date, :description, :price, :paid_type, :add_all_users, :calculate_amount, budget_attributes: [:amount], participant_ids: [], celebrator_ids: [])
    end
end
