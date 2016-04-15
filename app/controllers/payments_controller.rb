class PaymentsController < ApplicationController
  def update
    @payment = Payment.find(params[:id])
    respond_to do |format|
      if @payment.pay
        format.js { flash[:success] = 'Successfully paid' }
      else
        format.js { flash[:danger] = 'Try again' }
      end
    end
  end
end
