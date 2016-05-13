FactoryGirl.define do
  factory :event, :class => 'Event' do
    name { Faker::Name.title }
    description { Faker::Lorem.paragraph }
    date { Faker::Time.forward(23, :morning) }
    paid_type "free"
    add_all_users false
    calculate_amount false
  end

  factory :paid_event, parent: :event do
    paid_type "paid"
    calculate_amount true

    transient do
      participants_count 2
    end

    trait :with_participants_and_payments do
      after(:build) do |event, evaluator|
        event.participants << FactoryGirl.create_list(:user, evaluator.participants_count)
      end
    end
  end
end