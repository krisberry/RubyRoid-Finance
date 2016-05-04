class EventsController < ApplicationController
  before_action :event_params, only: [:create, :update]

  def index
    @events = if params[:user_id].present?
                current_user.events
              else
                current_user.created_events
              end
  end

  def show
    @event = Event.find(params[:id])
    @payment = current_user.payments.for_budget(@event.budget).first
    if @event.paid?
      @total_payments_amount = @event.paid_payments.inject(0) { |sum, p| sum + p.amount }
      @balance_to_paid = @event.unpaid_payments.inject(0) { |sum, p| sum + p.amount }
      @paid_percent = (@total_payments_amount/@event.budget.amount)*100
    end
  end

  def new
    @event = Event.new
  end

  def create
    params[:event].delete_if{ |key, value| ["calculate_amount", "budget_attributes"].include?(key)} if event_params[:paid_type] == "free"
    @event = current_user.created_events.build(event_params)
    if @event.save
      @event.participants.each do |participant|
        UserMailer.new_event_email(participant, @event).deliver_now
      end
      flash[:success] = "Event was successfully created"
      redirect_to events_path
    else
      flash[:danger] = "Some errors prohibited this event from being saved"
      render :new
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
      @not_notify = @event.participant_ids & @old_participant_ids.map(&:to_i)
      @event.participants.each do |participant|
        unless @not_notify.include?(participant.id)
          UserMailer.new_event_email(participant, @event).deliver_now
        end
      end
      flash[:success] = 'Event was successfully updated'
      redirect_to events_path
    else
      flash[:danger] = "Some errors prohibited this event from being saved"
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if current_user == @event.creator || current_user.admin?
      @event.destroy
      flash[:success] = 'Event was successfully deleted'
      redirect_to :back
    else
      flash[:danger] = 'Only creator or admin can delete this event.'
      redirect_to :back
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, :date, :description, :price, :paid_type, :add_all_users, :calculate_amount, budget_attributes: [:amount], participant_ids: [])
    end
end
