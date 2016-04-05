class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authorizations

  def self.from_omniauth(auth)
    provider, uid = auth.slice(:provider, :uid)
    includes(:authorizations).where("users.email = ? OR (authorizations.provider = ? AND authorizations.uid = ?)", auth.info.email , provider,  uid).references(:authorizations).first do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.birthday = auth.info.birthday
      user.authorizations.build({provider: auth.provider, uid: auth.uid, token: auth.credentials.token})
      user.save!
    end
  end
end