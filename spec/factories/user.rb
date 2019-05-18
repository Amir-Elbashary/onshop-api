FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password  { 'useruser' }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    avatar { Faker::Avatar.image }
  end
end
