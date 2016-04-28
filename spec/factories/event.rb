FactoryGirl.define do
  factory :event, :class => 'Event' do
    name { Faker::Name.title }
    description { Faker::Lorem.paragraph }
    date { Faker::Time.forward(23, :morning) }
    paid_type "free"
  end
end