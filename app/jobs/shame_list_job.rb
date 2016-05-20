class ShameListJob < ActiveJob::Base
  queue_as :default

  def perform
    Event.shame_notify.each do |event|
      if event.amount > event.items.sum(:amount)
        event.participants.each do |participant|
          UserMailer.shame_list_email(participant, event).deliver_now
        end
      end
    end
  end
end