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
      expect(User.first.authentication_token).not_to eq(@user.authentication_token)
    end

    it 'should be able to sign out' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.authentication_token }

      delete '/v1/user/sessions/id.json', headers: headers 

      expect(response.code).to eq('200')
      expect(User.first.authentication_token).not_to eq(@user.authentication_token)
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
