FactoryBot.define do
  factory :order do
    total_items { 8 }
    total_price { 800 }
    user
    cart
  end
end
