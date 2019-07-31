FactoryBot.define do
  factory :variant do
    color { Faker::Color.color_name }
    size { Faker::Number.decimal }
    price { Faker::Number.decimal }
    quantity { Faker::Number.number(2) }
    image { Faker::Avatar.image }
    product
  end
end
