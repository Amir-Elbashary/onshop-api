require 'rails_helper'

RSpec.describe 'Signing in/out as merchant', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant)
  end

  context 'with valid credentials' do
    it 'should be able to sign in' do
      headers = { 'X-APP-Token' => @app_token.token }
      params = { 'merchant[email]' => @merchant.email, 'merchant[password]' => @merchant.password }

      post '/v1/merchant/sessions.json', headers: headers, params: params

      expect(response.code).to eq('200')
      expect(Merchant.first.authentication_token).not_to eq(@merchant.authentication_token)
    end

    it 'should be able to sign out' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.authentication_token }

      delete '/v1/merchant/sessions/id.json', headers: headers 

      expect(response.code).to eq('200')
      expect(Merchant.first.authentication_token).not_to eq(@merchant.authentication_token)
    end
  end

  context 'with invalid credentials' do
    it 'should not be able to sign in' do
      headers = { 'X-APP-Token' => @app_token.token }
      params = { 'merchant[email]' => @merchant.email, 'merchant[password]' => 'wrong password' }

      post '/v1/merchant/sessions.json', headers: headers, params: params

      expect(response.code).to eq('422')
    end

    it 'should not be able to sign out' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'wrong token' }

      delete '/v1/merchant/sessions/id.json', headers: headers 

      expect(response.code).to eq('401')
    end
  end
end
