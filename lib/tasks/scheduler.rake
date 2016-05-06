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

task :send_event_notification_email => :environment do
  Event.should_notify.each do |event|
    event.participants.each do |participant|
      UserMailer.event_notification_email(participant, event).deliver_now
    end
  end
end

task :send_shame_list_email => :environment do
  Event.shame_notify.each do |event|
    event.participants.each do |participant|
     UserMailer.shame_list_email(participant, event).deliver_now
    end
  end
end
