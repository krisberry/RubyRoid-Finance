class Admin::EventsController < ApplicationController
  before_filter :admin_only

  def index
    @events = if params[:user_id]
      User.find(params[:user_id]).events.each do |event|
        [] << event if (event.amount > event.total)
      end
    elsif params[:creator_id]
      User.find(params[:creator_id]).created_events.order(order_query)
    else
      Event.order(order_query)
    end
  end

  def show
    @event = Event.find(params[:id])
    @items = (@event.items + @event.credit_items).paginate(per_page: 10, page: params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @event = Event.find(params[:id])
    render :edit
  end

  def destroy
    @event = Event.find(params[:id]).destroy
    flash[:success] = 'Event deleted'
    redirect_to :back
  end

  private

    def event_params
      params.require(:event).permit(:name, :date, :description, :amount, :paid_type, :add_all_users, :calculate_amount, participant_ids: [], celebrator_ids: [])
    end

  protected  

    def sortable_columns
      super.push("name", "date", "paid_type")
    end
end
