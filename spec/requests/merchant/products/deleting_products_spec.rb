require 'rails_helper'

RSpec.describe 'Deleting product', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.logins.first.token }
    @merchant_product = create(:product, merchant: @merchant)
    @others_product = create(:product)
  end

  context 'while providing product ID which belongs to the same merchant' do
    it 'should delete that product' do
      delete "/v1/merchant/products/#{@merchant_product.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Product.count).to eq(1)
    end
  end

  context 'while providing product ID which does not belong to the same merchant' do
    it 'should not delete that product' do
      delete "/v1/merchant/products/#{@others_product.id}", headers: @headers

      expect(response.code).to eq('422')
      expect(Product.count).to eq(2)
    end
  end

  context 'while providing invalid ID' do
    it 'should respond with not found' do
      delete "/v1/merchant/products/88", headers: @headers

      expect(response.code).to eq('404')
      expect(Product.count).to eq(2)
    end
  end
end
