class EventsController < ApplicationController
  before_action :event_params, only: [:create, :update]

  def index
    @events = if params[:user_id]
      current_user.events
    else params[:creator_id]
      current_user.created_events
    end
  end

  def show
    @event = Event.find(params[:id])
    @payment = current_user.payments.for_budget(@event.budget).first
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params.merge(user_id: current_user.id))

    @event.select_all_participants if event_params[:select_all] == "1"
    @event.default_budget if event_params[:default_amount] == "1"
   
    if @event.save
      @event.participants.each do |participant|
        UserMailer.new_event_email(participant, @event).deliver_now
      end
      flash[:success] = "Event was successfully created"
      redirect_to root_path
    else
      flash[:danger] = ""
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
    render :edit
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:success] = 'Event was successfully updated'
      redirect_to root_path
    else
      flash[:danger] = ""
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if current_user == @event.creator || current_user.admin?
      @event.destroy
      flash[:success] = 'Event deleted'
      redirect_to :back
    else
      flash[:danger] = 'Only creator or admin can delete this event.'
      redirect_to :back
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, :date, :description, :price, :paid_type, :select_all, :default_amount, budget_attributes: [:amount], participant_ids: [])
    end
end
