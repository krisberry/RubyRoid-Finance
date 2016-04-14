class Admin::UsersController < ApplicationController
  def index
    @users = User.order(order_query)
  end

  protected

    def sortable_columns
      super.push("email", "birthday", "first_name", "last_name")
    end 
end
