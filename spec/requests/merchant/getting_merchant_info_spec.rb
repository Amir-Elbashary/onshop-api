require 'rails_helper'

RSpec.describe 'Getting merchant info', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant_with_logins)
  end

  context 'with valid merchant token' do
    it 'should return merchant info' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.logins.first.token }

      get "/v1/merchant/merchants/id", headers: headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['id']).to eq(@merchant.id)
    end
  end

  context 'with invalid merchant token' do
    it 'should return unauthorized' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }

      get "/v1/merchant/merchants/id", headers: headers

      expect(response.code).to eq('401')
    end
  end
end
