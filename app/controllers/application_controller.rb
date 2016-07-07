class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_filter :authenticate_user!
  
  helper_method :sort_column, :sort_direction

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_root_path : authenticated_root_path 
  end

  protected

    def order_query
      if columns = sort_column
        if columns.is_a? Array
          columns.map do |column|
            "#{column} #{sort_direction}"
          end.join(", ")
        else
          "#{columns} #{sort_direction}"
        end
      end
    end  

    def sortable_columns
      []
    end

    def sort_column
      if params[:column].is_a? Array
        params[:column] if params[:column].all? { |column| sortable_columns.include?(column) }
      else
        params[:column] if sortable_columns.include?(params[:column]) 
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def admin_only
      unless current_user.admin?
        redirect_to authenticated_root_path, :alert => "Access denied."
      end
    end
end
