every :hour do
  runner "UsersNotificationJob.perform_later"
end

every :hour do
  runner "SentNotificationAboutDeletingInvitationJob.perform_later"
end

every :day do
  runner "EventNotificationJob.perform_later"
end

every :day do
  runner "ShameListJob.perform_later"
end