class Admin::DashboardController < ApplicationController
  before_filter :admin_only
  def index
    @events = Event.where("date IS NOT NULL")
    @custom_events = Event.where("date IS NULL")
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
  end
end
