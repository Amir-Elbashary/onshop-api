FactoryBot.define do
  factory :review do
    review { Faker::Lorem.paragraph(8) }
    rating { Faker::Number.between(0, 5) }
    user
    product
  end
end
