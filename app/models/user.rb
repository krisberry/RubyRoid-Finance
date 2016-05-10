class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:facebook]

  USER_RATES = { junior: 50, intermediate: 100, senior: 150 }

  enum role: { admin: '0', tax_collector: '1', user: '2' }

  has_one :image, as: :imageable, dependent: :destroy
  has_many :authorizations
  has_many :created_events, foreign_key: :user_id, class_name: 'Event', inverse_of: :creator, dependent: :destroy
  has_many :payments
  has_many :budgets, through: :payments
  has_and_belongs_to_many :events
  has_and_belongs_to_many :celebrated_events, foreign_key: :celebrator_id, class_name: 'Event', join_table: :celebrators_events
  
  accepts_nested_attributes_for :image
  
  def self.from_omniauth_log_in(auth)
    provider, uid = auth.slice(:provider, :uid)
    includes(:authorizations).where("users.email = ? OR (authorizations.provider = ? AND authorizations.uid = ?)", auth.info.email, provider, uid).references(:authorizations).first
  end

  def self.from_omniauth_sign_up(auth)
    includes(:authorizations, :image).build do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token(length = 8)
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.birthday = Date.strptime(auth.extra.raw_info.birthday, "%m/%d/%Y") if auth.extra.raw_info.birthday
      user.build_image({photo: open(auth.info.image)})
      user.authorizations.build({provider: auth.provider, uid: auth.uid, token: auth.credentials.token})
      user.save
      user
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end