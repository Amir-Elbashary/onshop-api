require 'rails_helper'

RSpec.describe 'Deleting product', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.authentication_token }
    @merchant_product = create(:product, merchant: @merchant)
    @others_product = create(:product)
    @m_variant = create(:variant, product: @merchant_product)
    @o_variant = create(:variant, product: @others_product)
  end

  context 'while providing product ID which belongs to the same merchant' do
    it 'should delete that product' do
      delete "/v1/merchant/products/#{@merchant_product.id}/variants/#{@m_variant.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Variant.count).to eq(1)
    end
  end

  context 'while providing product ID which does not belong to the same merchant' do
    it 'should not delete that product' do
      delete "/v1/merchant/products/#{@others_product.id}/variants/#{@o_variant.id}", headers: @headers

      expect(response.code).to eq('422')
      expect(Variant.count).to eq(2)
    end
  end

  context 'while providing invalid ID' do
    it 'should respond with not found' do
      delete "/v1/merchant/products/#{@others_product.id}/variants/88", headers: @headers

      expect(response.code).to eq('404')
      expect(Variant.count).to eq(2)
    end
  end
end
