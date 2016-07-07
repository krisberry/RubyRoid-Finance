FactoryGirl.define do
  factory :invitation_request, class: 'Invitation' do
    email { Faker::Internet.email }
  end

  factory :invitation, parent: :invitation_request, class: 'Invitation' do
    invited_code { Devise.friendly_token(length = 30) }
    approved { Faker::Boolean.boolean }
  end

  factory :should_expire_invitation, parent: :invitation_request, class: 'Invitation' do
    invited_code { Devise.friendly_token(length = 30) }
    approved true
    updated_at { Time.now - 37.hours }
  end

  factory :should_be_deleted_invitation, parent: :invitation_request, class: 'Invitation' do
    invited_code { Devise.friendly_token(length = 30) }
    approved true
    updated_at { Time.now - 49.hours }
  end
end