class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :sort_column, :sort_direction

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_root_path : root_path 
  end

  protected

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
        ["id"]
      end

      def sort_column
        if params[:column].is_a? Array
          params[:column].all? { |column| sortable_columns.include?(column) } ? params[:column] : "id"
        else
          sortable_columns.include?(params[:column]) ? params[:column] : "id"
        end
      end

      def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
      end
end
