class ShameListJob < ActiveJob::Base
  queue_as :default

  def perform
    Event.shame_notify.each do |event|
      event.participants.each do |participant|
        UserMailer.shame_list_email(participant, event).deliver_now unless event.celebrator_ids.include?(participant.id)
      end
    end
  end
end