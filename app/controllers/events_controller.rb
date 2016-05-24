class EventsController < ApplicationController
  before_action :event_params, only: [:create, :update]

  def index
    @events = if params[:user_id].present?
                current_user.events.order(order_query)
              else
                current_user.created_events.order(order_query)
              end
  end

  def show
    @event = Event.find(params[:id])
    @items = (@event.items + @event.credit_items).paginate(per_page: 10, page: params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @event = Event.new
  end

  def create
    refine_params_for_event

    @event = current_user.created_events.build(event_params)
    if @event.save
      @event.notify_participants
      
      flash[:success] = "Event was successfully created"
      redirect_to current_user.admin? ? admin_events_path : events_path
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
    @event = Event.find(params[:id])
    old_participant_ids = @event.participant_ids

    refine_params_for_event @event

    if @event.update(event_params)
      shoul_be_notify = @event.participant_ids - old_participant_ids
      @event.notify_participants shoul_be_notify

      flash[:success] = 'Event was successfully updated'
      redirect_to current_user.admin? ? admin_events_path : events_path
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
      params.require(:event).permit(:name, :date, :amount, :description, :paid_type, :add_all_users, :calculate_amount, participant_ids: [], celebrator_ids: [])
    end

    def refine_params_for_event event = nil
      # params[:event].delete_if{ |key, value| ["calculate_amount", "amount"].include?(key)} if event_params[:paid_type] == "free"
      params[:event][:amount] = nil if event_params[:calculate_amount] == "1"
      params[:event][:participant_ids] = [] if event_params[:add_all_users] == "1"
      params[:event][:participant_ids] -= params[:event][:celebrator_ids]
      params[:event][:participant_ids] += event.paid_participants_ids.map(&:to_s) if event
    end

  protected

    def sortable_columns
      super.push("name", "date", "paid_type")
    end
end
