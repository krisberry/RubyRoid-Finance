class Admin::DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only
  helper_method :sort_column, :sort_direction
  def index
    @users = User.order(order_query)
  end

  private

    def admin_only
      unless current_user.admin?
        redirect_to root_path, :alert => "Access denied."
      end
    end

    def order_query
      columns = sort_column
      if columns.is_a? Array
        sort_column.map do |column|
          "#{column} #{sort_direction}"
        end.join(", ")
      else
        "#{columns} #{sort_direction}"
      end  
    end  

    def sortable_columns
      ["email", "birthday", "first_name", "last_name"]
    end

    def sort_column
      if params[:column].is_a? Array
        params[:column].all? { |column| sortable_columns.include?(column) } ? params[:column] : "email"
      else
        sortable_columns.include?(params[:column]) ? params[:column] : "email"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
