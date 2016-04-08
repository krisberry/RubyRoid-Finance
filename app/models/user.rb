class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauth_providers => [:google_oauth2]
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authorizations
  has_one :image, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :image

  enum role: { admin: '0', tax_collector: '1', user: '2' }

  def self.from_omniauth(auth)
    provider, uid = auth.slice(:provider, :uid)
    includes(:authorizations, :image).where("users.email = ? OR (authorizations.provider = ? AND authorizations.uid = ?)", auth.info.email, provider,  uid).references(:authorizations).first_or_initialize do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token(length = 30)
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.birthday = Date.strptime(auth.extra.raw_info.birthday, "%m/%d/%Y") if auth.extra.raw_info.birthday
      user.build_image({photo: open(auth.info.image)})
      user.authorizations.build({provider: auth.provider, uid: auth.uid, token: auth.credentials.token})
      user.save
    end
  end
end