class Admin::RatesController < ApplicationController
  before_filter :admin_only

  add_flash_types :success, :danger

  def edit
    @rate = Rate.find(params[:id])
    render :edit
  end

  def update
    @rate = Rate.find(params[:id])
    respond_to do |format|
      if @rate.update(rate_params)
        format.html { redirect_to admin_rates_path, success: 'Rate was successfully updated' }
      else
        format.html do
          flash[:danger] = "Some errors prohibited this rate from being saved"
          render :edit
        end
      end
      format.json { respond_with_bip(@rate) }
    end
  end

  private
    def rate_params
      params.require(:rate).permit(:name, :amount, :description)
    end
end