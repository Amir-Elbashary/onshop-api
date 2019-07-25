FactoryBot.define do
  factory :merchant do
    email { Faker::Internet.unique.email }
    password  { 'merchantmerchant' }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    avatar { Faker::Avatar.image }

		factory :merchant_with_logins do
      transient do
        logins_count { 1 }
      end

      after(:create) do |merchant, evaluator|
				token = JWT.encode({ email: merchant.email }, ENV['SECRET_KEY_BASE'], 'HS256')
        create_list(:login, evaluator.logins_count, merchant: merchant, token: token)
      end
    end
  end
end
