require 'rails_helper'

RSpec.describe 'Attempting to access an API as a merchant', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant)
    token = JWT.encode({ email: @merchant.email, exp: -80 }, ENV['SECRET_KEY_BASE'], 'HS256')
    @login = create(:login, merchant: @merchant, token: token)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.logins.first.token }
  end

  context 'with expired token' do
    it 'should be asked to relogin' do
      params = { 'merchant[first_name]' => 'New', 'merchant[last_name]' => 'name' }

      put "/v1/merchant/merchants/#{@merchant.id}", headers: @headers, params: params

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('401')
      expect(Merchant.first.full_name).to eq(@merchant.full_name)
      expect(response_body['message']).to eq('session expired, please relogin')
    end
  end
end
