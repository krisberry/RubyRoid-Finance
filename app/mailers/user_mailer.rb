class UserMailer < ApplicationMailer
  default from: 'my@exemple.com'

  def invitation_email(user)
    @user = user
    # @invited_code = Devise.friendly_token(length = 60)
    mail(to: @user.email, subject: 'Invitation')
  end
end
