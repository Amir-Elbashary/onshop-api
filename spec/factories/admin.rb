FactoryBot.define do
  factory :admin do
    email { Faker::Internet.unique.email }
    password  { 'adminadmin' }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    avatar { Faker::Avatar.image }
  end
end
