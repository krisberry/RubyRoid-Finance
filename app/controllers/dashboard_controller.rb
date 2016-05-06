class DashboardController < ApplicationController
  def index
    @events = current_user.events.limit(10)
    @my_events = current_user.created_events.limit(10)
  end

  def calendar
    @events = current_user.events
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
  end

protected

    def sortable_columns
      super.push("name", "paid_type", "date")
    end 
end
