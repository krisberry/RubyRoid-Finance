FactoryGirl.define do
  factory :budget, :class => 'Budget' do
    amount { Faker::Number.decimal(4).to_f }
  end

  factory :budget_with_payments, class: "Budget" do
    transient do
      payments_count 3
    end

    after(:build) do |budget, evaluator|
      budget.payments << FactoryGirl.create_list(:payment_with_user, evaluator.payments_count)
    end
  end
end