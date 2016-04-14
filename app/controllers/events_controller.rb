class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_action :event_params, only: [:create]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.creator = current_user
    if @event.save
      flash[:success] = "Event was successfully created"
      redirect_to root_path
    end
  end

  def edit
    @event = Event.find(params[:id])
    render :edit
  end

  def update

  end

  def destroy
  end

  private

    def event_params
      params.require(:event).permit(:name, :date, :price, :paid_type, participant_ids: [])
    end
end
