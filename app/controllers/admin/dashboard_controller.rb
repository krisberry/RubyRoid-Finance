class Admin::DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only
  helper_method :sort_column, :sort_direction
  def index
    @users = User.order("#{sort_column} #{sort_direction}")
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def sortable_columns
    ["email", "birthday"]
  end

  def sort_column
    sortable_columns.include?(params[:column]) ? params[:column] : "last_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
