require 'rails_helper'

RSpec.describe 'Signing in/out as admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
  end

  context 'with valid credentials' do
    it 'should be able to sign in' do
      headers = { 'X-APP-Token' => @app_token.token }
      params = { 'admin[email]' => @admin.email, 'admin[password]' => @admin.password }

      post '/api/v1/admin/sessions.json', headers: headers, params: params

      expect(response.code).to eq('200')
    end

    it 'should be able to sign out' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }

      delete '/api/v1/admin/sessions/id.json', headers: headers 

      expect(response.code).to eq('200')
    end
  end

  context 'with invalid credentials' do
    it 'should not be able to sign in' do
      headers = { 'X-APP-Token' => @app_token.token }
      params = { 'admin[email]' => @admin.email, 'admin[password]' => 'wrong password' }

      post '/api/v1/admin/sessions.json', headers: headers, params: params

      expect(response.code).to eq('422')
    end

    it 'should not be able to sign out' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'wrong token' }

      delete '/api/v1/admin/sessions/id.json', headers: headers 

      expect(response.code).to eq('401')
    end
  end
end
