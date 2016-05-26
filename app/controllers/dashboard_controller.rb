class DashboardController < ApplicationController
  def index
    @events = current_user.events.limit(10)
    @my_events = current_user.created_events.limit(10)
  end

  def calendar
    @custom_events = current_user.events.where("date IS NULL")
    @events = current_user.events.where("date IS NOT NULL")
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
  end

protected

    def sortable_columns
      super.push("name", "paid_type", "date")
    end 
end
