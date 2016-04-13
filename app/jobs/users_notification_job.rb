class UsersNotificationJob < ActiveJob::Base
  queue_as :default

  def perform
    Invitation.should_expire.each do |invitation|
      UserMailer.notification_email(invitation).deliver_now
    end
  end
end
