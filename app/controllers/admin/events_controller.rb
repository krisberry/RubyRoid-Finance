class Admin::EventsController < ApplicationController
  before_filter :admin_only

  def index
    @events = if params[:user_id]
      User.find(params[:user_id]).events.unpaid.order(order_query)
    elsif params[:creator_id]
      User.find(params[:creator_id]).created_events.order(order_query)
    else
      Event.order(order_query)
    end
  end

  def show
    @event = Event.find(params[:id])
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
    params[:event][:participant_ids] -= params[:event][:celebrator_ids]
    @event = Event.find(params[:id])
    @old_participant_ids = @event.participant_ids
    if @event.update(event_params)
      @not_notify = (@event.participant_ids & @old_participant_ids.map(&:to_i))
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
    @event = @payment.event
    respond_to do |format|
      if @payment.items.create(amount: @payment.amount)
        format.js { flash[:success] = 'Successfully paid' }
      else
        format.js { flash[:danger] = 'Try again' }
      end
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, :date, :description, :amount, :paid_type, :add_all_users, :calculate_amount, participant_ids: [], celebrator_ids: [])
    end

  protected  

    def sortable_columns
      super.push("name", "date", "paid_type")
    end
end
