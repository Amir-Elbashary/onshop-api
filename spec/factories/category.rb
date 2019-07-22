FactoryBot.define do
  factory :category do
    name { Faker::Name.unique.name.downcase.strip.squish }
    image { Faker::Avatar.image }

    factory :sub_category do
      parent_id { 1 }
    end
  end
end
