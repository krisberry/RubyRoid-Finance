class UserMailer < ApplicationMailer
  default from: 'my@heroku.com'

  def invitation_email(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: 'Invitation')
  end

  def notification_email(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: 'Warning')
  end

  def deleting_invitation_email(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: 'Bad news')
  end

  def new_event_email(participant, event)
    @participant = participant
    @event = event
    mail(to: @participant.email, subject: 'New event')
  end

  def event_notification_email(participant, event)
    @participant = participant
    @event = event
    mail(to: @participant.email, subject: 'Reminding')
  end

  def shame_list_email(participant, event)
    @participant = participant
    @event = event
    mail(to: @participant.email, subject: 'Shameboard')
  end

  def send_password(user)
    @user = user
    mail(to: @user.email, subject: 'Password')
  end
end
