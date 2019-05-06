require 'rails_helper'

RSpec.describe 'Listing products', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.authentication_token }
    @merchant_product1 = create(:product, merchant: @merchant)
    @merchant_product2 = create(:product, merchant: @merchant)
    @others_product = create(:product)
  end

  context 'when presenting valid merchant token' do
    it 'should list this merchant products only' do
      get '/v1/merchant/products', headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
    end
  end

  context 'when presenting invalid merchant token' do
    it 'should not return any products' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }
      get '/v1/merchant/products', headers: headers

      expect(response.code).to eq('401')
    end
  end
end
