FactoryBot.define do
  factory :product do
    name { Faker::Name.unique.name.downcase.strip.squish }
    description { Faker::Lorem.paragraph(8) }
    image { Faker::Avatar.image }
    merchant
    category
  end
end
