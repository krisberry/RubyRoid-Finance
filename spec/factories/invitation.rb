FactoryGirl.define do
  factory :invitation_request, class: 'Invitation' do
    email { Faker::Internet.email }
  end

  factory :invitation, parent: :invitation_request, :class => 'Invitation' do
    invited_code { Devise.friendly_token(length = 30) }
    approved { Faker::Boolean.boolean }
  end
end