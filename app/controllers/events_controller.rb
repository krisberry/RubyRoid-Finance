class EventsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @events = Event.order(order_query)
  end

  def new
    @event = Event.new
  end

  def create
  end

  def update
  end

  def destroy
  end
end
