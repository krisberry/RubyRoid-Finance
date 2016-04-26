task :deleting_invitation_email => :environment do
  Invitation.should_delete.each do |invitation|
    UserMailer.deleting_invitation_email(invitation).deliver_now
    invitation.destroy
  end
end

task :send_notification_email => :environment do
  Invitation.should_expire.each do |invitation|
    UserMailer.notification_email(invitation).deliver_now
  end
end