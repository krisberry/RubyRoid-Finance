every :hour do
  runner "UsersNotificationJob.perform_later"
end

every :hour do
  runner "SentNotificationAboutDeletingInvitationJob.perform_later"
end