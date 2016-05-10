class EventNotificationJob < ActiveJob::Base
  queue_as :default

  def perform
    Event.should_notify.each do |event|
      event.participants.each do |participant|
        UserMailer.event_notification_email(participant, event).deliver_now unless event.celebrator_ids.include?(participant.id)
      end
    end
  end
end
