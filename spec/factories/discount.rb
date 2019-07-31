FactoryBot.define do
  factory :discount do
    percentage { Faker::Number.number(2) }
    starts_at { Time.now  }
    ends_at { Time.now + 4.days }
    merchant
    product
  end
end
