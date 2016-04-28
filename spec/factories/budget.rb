FactoryGirl.define do
  factory :budget, :class => 'Budget' do
    amount { Faker::Number.decimal(4) }
  end
end