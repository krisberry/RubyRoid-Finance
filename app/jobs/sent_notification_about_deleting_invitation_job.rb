class SentNotificationAboutDeletingInvitationJob < ActiveJob::Base
  queue_as :default

  def perform
    Invitation.should_delete.each do |invitation|
      UserMailer.deleting_invitation_email(invitation).deliver_now
      invitation.destroy
    end
  end
end
