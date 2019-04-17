FactoryBot.define do
  factory :app_token do
    title { Faker::Name.unique.name }
  end
end
