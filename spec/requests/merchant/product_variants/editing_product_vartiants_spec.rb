require 'rails_helper'

RSpec.describe 'Editing products by merchant', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.logins.first.token }
    @merchant_product = create(:product, merchant: @merchant)
    @others_product = create(:product)
    @m_variant = create(:variant, product: @merchant_product)
    @o_variant = create(:variant, product: @others_product)
  end

  context 'editing owned product with valid data' do
    it 'should update product variant' do
      params = { 'variant[product_id]' => @merchant_product.id,
                 'variant[color_en]' => 'Blue',
                 'variant[color_ar]' => 'ازرق',
                 'variant[size_en]' => 'Medium',
                 'variant[size_ar]' => 'وسط',
                 'variant[price]' => '18.88',
                 'variant[discount]' => '0.88',
                 'variant[quantity]' => '8',
                 'variant[image]' => '' }

      put "/v1/merchant/products/#{@merchant_product.id}/variants/#{@m_variant.id}", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(@merchant.products.first.variants.first.color_en).to eq('Blue')
      expect(@merchant.products.first.variants.first.size_ar).to eq('وسط')
    end
  end

  context 'editing owned product with invalid data' do
    it 'should not update product variant info' do
      params = { 'variant[product_id]' => @merchant_product.id,
                 'variant[color_en]' => '',
                 'variant[color_ar]' => 'ازرق',
                 'variant[size_en]' => 'Medium',
                 'variant[size_ar]' => 'وسط',
                 'variant[price]' => 'number',
                 'variant[discount]' => '0.88',
                 'variant[quantity]' => '-1',
                 'variant[image]' => '' }

      put "/v1/merchant/products/#{@merchant_product.id}/variants/#{@m_variant.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(@merchant.products.first.variants.first.color_en).to eq(@m_variant.color_en)
    end
  end

  context 'attempting to edit others product' do
    it 'should not allow to edit the product variant info' do
      params = { 'variant[product_id]' => @others_product.id,
                 'variant[color_en]' => '',
                 'variant[color_ar]' => 'ازرق',
                 'variant[size_en]' => 'Medium',
                 'variant[size_ar]' => 'وسط',
                 'variant[price]' => 'number',
                 'variant[discount]' => '0.88',
                 'variant[quantity]' => '8',
                 'variant[image]' => '' }

      put "/v1/merchant/products/#{@others_product.id}/variants/#{@o_variant.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Product.where.not(merchant_id: @merchant.id).first.variants.first.color_en).to eq(@o_variant.color_en)
    end
  end
end
