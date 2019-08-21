source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# ================== Main App Gems ==================
gem 'rails', '~> 5.2.2'
gem 'puma', '~> 3.11'
gem 'pg', '>= 0.18', '< 2.0'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'tzinfo-data'
gem 'dotenv-rails'
gem 'globalize', '~> 5.2'
gem 'globalize-accessors', '~> 0.2.1'
gem 'globalize-validations', '~> 0.0.4'
gem 'acts_as_tree', '~> 2.9'
gem 'will_paginate', '~> 3.1', '>= 3.1.7'

# =============== Authentication Gems ===============
gem 'devise', '~> 4.6', '>= 4.6.1'
gem 'cancancan', '~> 2.3'
gem 'omniauth-facebook', '~> 5.0'
gem 'jwt'

# ================ APIs Related Gems ================
gem 'jbuilder', '~> 2.5'
gem 'swagger-docs'
gem 'rack-cors'

# ============ Action Cable Related Gems ============
# gem 'redis', '~> 4.0'

# =============== Images Related Gems ===============
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'mini_magick', '~> 4.9', '>= 4.9.3'

# =============== Development & Test ================
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
  gem 'factory_bot', '~> 5.0', '>= 5.0.2'
  gem 'faker', '~> 1.9', '>= 1.9.3'
  gem 'guard', '~> 2.15'
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3'
end

# ===================== Testing =====================
group :test do
  gem 'database_cleaner', '~> 1.7'
  gem 'shoulda-matchers', '~> 4.0', '>= 4.0.1'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.4'
end

# =================== Development ===================
group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd', '~> 1.5', '>= 1.5.2'
  gem 'letter_opener'

  # ============ Deployment Related Gems ============
  gem 'capistrano', '~> 3.7', '>= 3.7.1'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-rbenv', '~> 2.1'
end
