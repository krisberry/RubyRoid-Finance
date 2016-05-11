class ShameListJob < ActiveJob::Base
  queue_as :default

  def perform
    Event.with_missing_payment.shame_notify.each do |event|
      event.participants.each do |participant|
        UserMailer.shame_list_email(participant, event).deliver_now
      end
    end
  end
end