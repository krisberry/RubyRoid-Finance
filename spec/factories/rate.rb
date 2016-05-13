FactoryGirl.define do 
  factory :rate, class: "Rate" do
    name { Faker::Name.first_name}
    amount { Faker::Number.decimal(2).to_f}
  end
end