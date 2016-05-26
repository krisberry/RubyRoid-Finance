class Admin::ItemsController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    @payment = Payment.find(params[:payment_id]) if params[:payment_id]
    @item = Item.new
  end

  def create
    @event = Event.find(params[:event_id])
    if params[:item][:payment_id].present?
      @item = Item.new(item_params.merge!(credit: false, created_by: current_user))
    else
      @item = Item.new(item_params.merge!(credit: true, created_by: current_user))
    end
    respond_to do |format|
      if @item.save
        format.js { flash[:success] = 'Successfully paid' }
      else
        format.js { flash[:danger] = @item.errors.full_messages.first }
      end
    end
  end

  private

    def item_params
      params.require(:item).permit(:amount, :event_id, :payment_id, :created_by, :credit)
    end
end
