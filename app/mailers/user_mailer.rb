class UserMailer < ApplicationMailer
  default from: 'my@exemple.com'

  def invitation_email(invitation)
    @invitation = invitation
    # @invited_code = Devise.friendly_token(length = 60)
    mail(to: @invitation.email, subject: 'Invitation')
  end
end
