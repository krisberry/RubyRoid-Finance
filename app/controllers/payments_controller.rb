class PaymentsController < ApplicationController
  def index
    @payments = current_user.payments.only_paid
  end
end
