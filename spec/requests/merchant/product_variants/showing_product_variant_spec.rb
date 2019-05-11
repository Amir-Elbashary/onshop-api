require 'rails_helper'

RSpec.describe 'Showing product variant', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.authentication_token }
    @product = create(:product, merchant: @merchant)
    @product_variant = create(:variant, product: @product)
    @other_product_variant = create(:variant)
  end

  describe 'when presenting valid variant ID' do
    context 'if this variant/products belongs to merchant' do
      it 'should show this variant and it\'s products' do
        get "/v1/merchant/products/#{@product.id}/variants/#{@product_variant.id}", headers: @headers

        expect(response.code).to eq('200')
      end
    end

    context 'if this variant/products doesn\'t belong to merchant' do
      it 'shouldn\'t show this variant or it\'s products' do
        get "/v1/merchant/products/#{@other_product_variant.product.id}/variants/#{@other_product_variant.id}", headers: @headers

        expect(response.code).to eq('422')
      end
    end
  end

  context 'when presenting invalid product ID' do
    it 'should not return any variants' do
      get "/v1/merchant/products/88/variants/#{@product_variant.id}", headers: @headers

      expect(response.code).to eq('404')
    end
  end

  context 'when presenting invalid variant ID' do
    it 'should not return any variants' do
      get "/v1/merchant/products/#{@product.id}/variants/88", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
