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
      expect(Merchant.first.logins.count).to eq(1)
      expect(Merchant.first.logins.first.token).not_to eq(nil)
    end

    it 'should be able to sign out' do
      @login = create(:login, merchant: @merchant)
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.logins.first.token }

      delete '/v1/merchant/sessions/id.json', headers: headers 

      expect(response.code).to eq('200')
      expect(Merchant.first.logins.count).to eq(1)
      expect(Merchant.first.logins.first.token).to eq(nil)
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
