FactoryGirl.define do
  factory :invitation, :class => 'Invitation' do
    email { Faker::Internet.email }
    invited_code { Devise.friendly_token(length = 30) }
    approved { Faker::Boolean.boolean }
  end
end