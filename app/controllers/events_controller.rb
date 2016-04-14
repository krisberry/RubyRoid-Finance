class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_action :event_params, only: [:create]
  def index
    @events = Event.order(order_query)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:success] = "Event was successfully created"
      redirect_to :back
    end
  end

  def update
  end

  def destroy
  end

  private

  def event_params
    params.require(:event).permit(:name, :date, :price, :paid_type)
  end
end
