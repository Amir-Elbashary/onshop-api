FactoryBot.define do
  factory :offer do
    percentage { Faker::Number.number(2) }
    starts_at { Time.now  }
    ends_at { Time.now + 4.days }
    category
  end
end
