FactoryBot.define do
  factory :login do
    token { Faker::Alphanumeric.alpha(20) }
  end
end
