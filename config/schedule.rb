every 1.minutes do
  runner "UsersNotificationJob.perform_later"
end
