class PaymentsController < ApplicationController
  def update
    @payment = Payment.find(params[:id])
    if @payment.update(paymets_params)
      flash[:success] = 'Event was successfully updated'
      redirect_to root_path
    end
  end

private
    def paymets_params
      params.require(:payment).permit(:amount)
    end
end
