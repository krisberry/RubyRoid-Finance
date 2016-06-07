class UsersController < ApplicationController
  def autocomplete
    @users = User.where("first_name like ? OR last_name like ?", "%#{params[:term]}%", "%#{params[:term]}%")
    respond_to do |format|
      format.json
    end
  end
end