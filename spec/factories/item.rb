FactoryGirl.define do
  factory :item do 
    amount { Faker::Number.decimal(2).to_f }
    credit false
  end

  factory :credit_item, parent: :item, class: "Item" do
    credit true
  end
end