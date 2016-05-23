class Admin::ItemsController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    @payment = Payment.find(params[:payment_id])
    @item = Item.new
  end

  def create
    @event = Event.find(params[:event_id])
    @item = Item.new(item_params)
    respond_to do |format|
      if @item.save
        format.js { flash[:success] = 'Successfully paid' }
        redirect_to admin_event_path(@event)
      else
        format.js { flash[:danger] = 'Try again' }
        redirect_to :back
      end
    end
  end

  private

    def item_params
      params.require(:item).permit(:amount, :event_id, :payment_id)
    end
end
