class Admin::UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    @users = User.order(order_query)
  end
end
