FactoryBot.define do
  factory :contact do
    user_name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.phone_number }
    message { Faker::Lorem.paragraph(8) }
  end
end
