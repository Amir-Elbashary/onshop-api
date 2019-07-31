require 'rails_helper'

RSpec.describe 'Listing discounts as a merchant', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant_with_logins)
    @merchant_product1 = create(:product, merchant: @merchant)
    @merchant_product1_discount = create(:discount, merchant: @merchant, product: @merchant_product1)
    @merchant_product2 = create(:product, merchant: @merchant)
    @merchant_product2_discount = create(:discount, merchant: @merchant, product: @merchant_product2)
    @others_product = create(:product)
    @merchant_product1_discount = create(:discount, merchant: @others_product.merchant, product: @others_product)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.logins.first.token }
  end

  context 'when presenting valid merchant token' do
    it 'should list this merchant discounts only' do
      get '/v1/merchant/discounts', headers: @headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
    end
  end

  context 'when presenting invalid merchant token' do
    it 'should not return any discounts' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }
      get '/v1/merchant/discounts', headers: headers

      expect(response.code).to eq('401')
    end
  end
end
