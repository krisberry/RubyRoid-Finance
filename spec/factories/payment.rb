FactoryGirl.define do
  factory :payment, :class => 'Payment' do
    amount { Faker::Number.decimal(2) }
  end
end