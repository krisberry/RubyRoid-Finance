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

task :create_birthday_events => :environment do
  User.all.each do |user|
    if user.birthday && user.birthday == Time.current.midnight + 3.weeks
      admin = User.where(role: "0").first
      event = admin.created_events.create!(name: "#{user.full_name} birthday", 
                   description: "Pay the bill in a week, please.",
                   paid_type: "paid",
                   calculate_amount: true,
                   celebrator_ids: user.id,
                   date: user.birthday,
                   add_all_users: true
                  )
      event.participants.each do |participant|
        UserMailer.new_event_email(participant, event).deliver_now unless event.celebrator_ids.include?(participant.id)
      end
    end
  end
end
