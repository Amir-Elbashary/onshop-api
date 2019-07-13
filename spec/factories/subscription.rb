FactoryBot.define do
  factory :subscription do
    email { Faker::Internet.unique.email }
  end
end
