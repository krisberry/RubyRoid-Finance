FactoryGirl.define do
  factory :payment, :class => 'Payment' do
    amount { Faker::Number.decimal(2).to_f }
  end

  factory :payment_with_user, parent: :payment, class: "Payment" do 
    after(:build) do |payment|
      payment.user = FactoryGirl.create(:user)
    end
  end
end