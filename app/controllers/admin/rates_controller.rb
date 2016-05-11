class Admin::RatesController < ApplicationController
  before_filter :admin_only

  def edit
    @rate = Rate.find(params[:id])
    render :edit
  end

  def update
    @rate = Rate.find(params[:id])
    if @rate.update(rate_params)
      flash[:success] = 'Rate was successfully updated'
      redirect_to admin_rates_path
    else
      flash[:danger] = "Some errors prohibited this rate from being saved"
      render :edit
    end
  end

  private
    def rate_params
      params.require(:rate).permit(:name, :amount, :description)
    end
end