FactoryGirl.define do
  factory :user, :class => 'User' do
    email { Faker::Internet.email }
    password '12345678'
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthday { Faker::Time.between(DateTime.now - 50.years, DateTime.now) }
    phone { Faker::PhoneNumber.cell_phone }
    role "2"

    rate
  end

  factory :admin, parent: :user, class: "User" do
    role "0"
  end

  factory :user_with_events, parent: :user, class: "User" do
    after(:build) do |user|
      user.created_events << FactoryGirl.create(:paid_event)
      user.events << FactoryGirl.create(:paid_event, :with_participants_and_payments)
    end
  end
end