class Admin::DashboardController < ApplicationController
  before_filter :admin_only
  def index
    @events = current_user.events
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
  end
end
