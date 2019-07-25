FactoryBot.define do
  factory :admin do
    email { Faker::Internet.unique.email }
    password  { 'adminadmin' }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    avatar { Faker::Avatar.image }

		factory :admin_with_logins do
      transient do
        logins_count { 1 }
      end

      after(:create) do |admin, evaluator|
				token = JWT.encode({ email: admin.email }, ENV['SECRET_KEY_BASE'], 'HS256')
        create_list(:login, evaluator.logins_count, admin: admin, token: token)
      end
    end
  end
end
