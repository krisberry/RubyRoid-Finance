class Admin::UsersController < ApplicationController
  def index
    @users = User.order(order_query)
  end
end
