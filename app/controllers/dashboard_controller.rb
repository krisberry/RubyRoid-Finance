class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
    @events = current_user.events
    @my_events = current_user.created_events
  end

protected

    def sortable_columns
      super.push("name", "paid_type", "date")
    end 
end
