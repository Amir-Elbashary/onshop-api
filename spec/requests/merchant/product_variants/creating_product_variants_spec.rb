require 'rails_helper'

RSpec.describe 'Creating product variant as merchant', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant_with_logins)
    @product = create(:product, merchant: @merchant)
    @other_merchant = create(:merchant)
    @others_product = create(:product, merchant: @other_merchant)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.logins.first.token }
  end

  context 'with valid data' do
    it 'should create a product variant that is pending to be approved' do
      params = { 'variant[product_id]' => @product.id,
                 'variant[color_en]' => 'Blue',
                 'variant[color_ar]' => 'ازرق',
                 'variant[size_en]' => 'Medium',
                 'variant[size_ar]' => 'وسط',
                 'variant[price]' => '18.88',
                 'variant[discount]' => '0.88',
                 'variant[quantity]' => '8',
                 'variant[image]' => '' }

      post "/v1/merchant/products/#{@product.id}/variants", headers: @headers, params: params

      expect(response.code).to eq('201')
      expect(Variant.first.color_en).not_to eq(Variant.first.color_ar)
      expect(Product.first.variants.count).to eq(1)
    end
  end

  context 'with invalid data' do
    it 'should not create a product variant' do
      params = { 'variant[product_id]' => @product.id,
                 'variant[color_en]' => '',
                 'variant[color_ar]' => 'ازرق',
                 'variant[size_en]' => 'Medium',
                 'variant[size_ar]' => 'وسط',
                 'variant[price]' => 'number',
                 'variant[discount]' => '0.88',
                 'variant[quantity]' => '-1',
                 'variant[image]' => '' }

      post "/v1/merchant/products/#{@product.id}/variants", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Variant.count).to eq(0)
    end
  end

  context 'attempting to add to others product' do
    it 'should not allow to add to others product' do
      params = { 'variant[product_id]' => @others_product.id,
                 'variant[color_en]' => 'Blue',
                 'variant[color_ar]' => 'ازرق',
                 'variant[size_en]' => 'Medium',
                 'variant[size_ar]' => 'وسط',
                 'variant[price]' => '18.88',
                 'variant[discount]' => '0.88',
                 'variant[quantity]' => '8',
                 'variant[image]' => '' }

      post "/v1/merchant/products/#{@others_product.id}/variants", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Variant.count).to eq(0)
    end
  end
end
