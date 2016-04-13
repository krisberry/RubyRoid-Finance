class UserMailer < ApplicationMailer
  default from: 'my@exemple.com'

  def invitation_email(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: 'Invitation')
  end

  def notification_email(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: 'Warning')
  end
end
