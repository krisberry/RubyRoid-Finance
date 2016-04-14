class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_action :event_params, only: [:create, :update]

  def new
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params.merge(user_id: current_user.id))
    if @event.save
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
    @event = Event.find(params[:id]).destroy
    flash[:success] = 'Event deleted'
    redirect_to :back
  end

  private

    def event_params
      params.require(:event).permit(:name, :date, :description, :price, :paid_type, budget_attributes: [:amount], participant_ids: [])
    end
end
