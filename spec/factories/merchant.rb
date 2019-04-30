FactoryBot.define do
  factory :merchant do
    email { Faker::Internet.unique.email }
    password  { 'merchantmerchant' }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    avatar { Faker::Avatar.image }
  end
end
