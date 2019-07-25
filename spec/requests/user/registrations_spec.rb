require 'rails_helper'

RSpec.describe 'User registration', type: :request do
  before do
    @app_token = create(:app_token)
  end

  scenario 'can register manually' do
    expect(User.count).to eq(0)

    headers = { 'X-APP-Token' => @app_token.token }
    params = { 'user[email]' => 'user@test.com',
               'user[password]' => 'useruser',
               'user[password_confirmation]' => 'useruser',
               'user[first_name]' => 'OnShop',
               'user[last_name]' => 'User'
             }

    post '/v1/user/registrations.json', headers: headers, params: params

    expect(response.code).to eq('200')
    expect(User.count).to eq(1)
    expect(User.first.logins.first.token).not_to eq(nil)
  end

  scenario 'can register via facebook' do
    expect(User.count).to eq(0)

    headers = { 'X-APP-Token' => @app_token.token }
    params = { 'user[email]' => 'user@facebook.com',
               'user[password]' => 'some random generated password',
               'user[password_confirmation]' => 'some random generated password',
               'user[first_name]' => 'OnShop',
               'user[last_name]' => 'User',
               'user[provider]' => 'Facebook',
               'user[uid]' => '88888888'
             }

    post '/v1/user/registrations/social_media.json', headers: headers, params: params

    expect(response.code).to eq('200')
    expect(User.count).to eq(1)
    expect(User.first.logins.first.token).not_to eq(nil)
    expect(User.first.provider).to eq('Facebook')
    expect(User.first.uid).to eq('88888888')
  end

  scenario 'can register via gmail' do
    expect(User.count).to eq(0)

    headers = { 'X-APP-Token' => @app_token.token }
    params = { 'user[email]' => 'user@gmail.com',
               'user[password]' => 'some random generated password',
               'user[password_confirmation]' => 'some random generated password',
               'user[first_name]' => 'OnShop',
               'user[last_name]' => 'User',
               'user[provider]' => 'Gmail',
               'user[uid]' => '88888888'
             }

    post '/v1/user/registrations/social_media.json', headers: headers, params: params

    expect(response.code).to eq('200')
    expect(User.count).to eq(1)
    expect(User.first.logins.first.token).not_to eq(nil)
    expect(User.first.provider).to eq('Gmail')
    expect(User.first.uid).to eq('88888888')
  end
end
