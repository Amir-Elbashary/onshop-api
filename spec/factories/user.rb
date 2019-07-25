FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password  { 'useruser' }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    avatar { Faker::Avatar.image }

		factory :user_with_logins do
      transient do
        logins_count { 1 }
      end

      after(:create) do |user, evaluator|
				token = JWT.encode({ email: user.email }, ENV['SECRET_KEY_BASE'], 'HS256')
        create_list(:login, evaluator.logins_count, user: user, token: token)
      end
    end
  end
end
