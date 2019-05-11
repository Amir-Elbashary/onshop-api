require 'rails_helper'

RSpec.describe 'Showing product variant', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.authentication_token }
    @product = create(:product, merchant: @merchant)
    @product_variant1 = create(:variant, product: @product)
    @product_variant2 = create(:variant, product: @product)
    @others_product = create(:product)
  end

  describe 'when presenting valid product ID' do
    context 'if this product belongs to merchant' do
      it 'should show this product info and it\'s variants' do
        get "/v1/merchant/products/#{@product.id}", headers: @headers
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body['id']).to eq(@product.id)
        expect(response_body['variants'].count).to eq(2)
      end
    end

    context 'if this product doesn\'t belong to merchant' do
      it 'shouldn\'t show this product' do
        get "/v1/merchant/products/#{@others_product.id}", headers: @headers

        expect(response.code).to eq('422')
      end
    end
  end

  context 'when presenting invalid product ID' do
    it 'should not return any variants' do
      get "/v1/merchant/products/88", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
