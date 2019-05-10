require 'rails_helper'

RSpec.describe 'Listing products', type: :request do
  before do
    @app_token = create(:app_token)
    @headers = { 'X-APP-Token' => @app_token.token }
    @product = create(:product)
    @variant1 = create(:variant, product: @product)
    @variant2 = create(:variant, product: @product)
  end

  context 'when providing valid product id' do
    it 'should return this product info' do
      get "/v1/onshop/products/#{@product.id}", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['name']).to eq(@product.name)
      expect(response_body['variants'][0]['color']).to eq(@variant1.color)
      expect(response_body['variants'][1]['color']).to eq(@variant2.color)
    end
  end

  context 'when providing invalid product id' do
    it 'should return 404 error' do
      get "/v1/onshop/products/88", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
