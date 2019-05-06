FactoryBot.define do
  factory :variant do
    color { Faker::Color.color_name }
    size { Faker::Number.decimal }
    price { Faker::Number.decimal }
    discount { Faker::Number.decimal }
    image { Faker::Avatar.image }
    product
  end
end
