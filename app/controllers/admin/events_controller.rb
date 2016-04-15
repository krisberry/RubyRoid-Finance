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
end
