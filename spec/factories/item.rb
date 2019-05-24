FactoryBot.define do
  factory :item do
    quantity { Faker::Number.number(2) }
    cart
    variant
  end
end
