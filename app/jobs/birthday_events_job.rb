class BirthdayEventsJob < ActiveJob::Base
  queue_as :default

  def perform
    User.all.each do |user|
      if user.upcoming_birthday?
        admin = User.find_by(role: "0")
        event = admin.created_events.create!(name: "#{user.full_name} birthday", 
                     description: "Pay the bill in a week, please.",
                     paid_type: "paid",
                     calculate_amount: true,
                     celebrator_ids: user.id,
                     date: user.upcoming_birthday,
                     add_all_users: true
                    )
        event.participants.each do |participant|
          UserMailer.new_event_email(participant, event).deliver_now unless event.celebrator_ids.include?(participant.id)
        end
      end
    end
  end

end
