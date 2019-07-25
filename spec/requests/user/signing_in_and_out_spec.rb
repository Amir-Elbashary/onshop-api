require 'rails_helper'

RSpec.describe 'Signing in/out as user', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
  end

  context 'with valid credentials' do
    it 'should be able to sign in' do
      headers = { 'X-APP-Token' => @app_token.token }
      params = { 'user[email]' => @user.email, 'user[password]' => @user.password }

      post '/v1/user/sessions.json', headers: headers, params: params

      expect(response.code).to eq('200')
      expect(User.first.logins.count).to eq(1)
      expect(User.first.logins.first.token).not_to eq(nil)
    end

    it 'should be able to sign out' do
      @login = create(:login, user: @user)
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }

      delete '/v1/user/sessions/id.json', headers: headers 

      expect(response.code).to eq('200')
      expect(User.first.logins.count).to eq(1)
      expect(User.first.logins.first.token).to eq(nil)
    end
  end

  context 'with invalid credentials' do
    it 'should not be able to sign in' do
      headers = { 'X-APP-Token' => @app_token.token }
      params = { 'user[email]' => @user.email, 'user[password]' => 'wrong password' }

      post '/v1/user/sessions.json', headers: headers, params: params

      expect(response.code).to eq('422')
    end

    it 'should not be able to sign out' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'wrong token' }

      delete '/v1/user/sessions/id.json', headers: headers 

      expect(response.code).to eq('401')
    end
  end
end
