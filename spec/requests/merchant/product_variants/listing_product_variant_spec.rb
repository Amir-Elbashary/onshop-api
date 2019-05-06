require 'rails_helper'

RSpec.describe 'Listing product variants', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant)
    @product = create(:product, merchant: @merchant)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.authentication_token }
    @product_variant1 = create(:variant, product: @product)
    @product_variant2 = create(:variant, product: @product)
    @other_product_variant = create(:variant)
  end

  context 'when presenting valid product ID' do
    it 'should list this product variants only' do
      get "/v1/merchant/products/#{@product.id}/variants", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
    end
  end

  context 'when presenting invalid product ID' do
    it 'should not return any variants' do
      get "/v1/merchant/products/88/variants", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
