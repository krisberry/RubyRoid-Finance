FactoryGirl.define do
  factory :user, :class => 'User' do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthday { Faker::Time.between(DateTime.now - 50.years, DateTime.now) }
    phone { Faker::PhoneNumber.cell_phone }
    role "2"

    rate
  end
end