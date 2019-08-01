FactoryBot.define do
  factory :coupon do
    percentage { Faker::Number.number(2) }
    code { Faker::Code.unique.nric }
    starts_at { Time.now  }
    ends_at { Time.now + 4.days }
  end
end
