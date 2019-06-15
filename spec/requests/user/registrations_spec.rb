require 'rails_helper'

RSpec.describe 'User registration', type: :request do
  before do
    @app_token = create(:app_token)
  end

  scenario 'should register manually' do
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
    expect(User.first.authentication_token).not_to eq(nil)
  end
end
