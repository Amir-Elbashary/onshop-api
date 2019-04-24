require 'rails_helper'

RSpec.describe 'Deleting product', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.authentication_token }
    @product = create(:product)
  end

  context 'while providing product ID' do
    it 'should delete that product' do
      delete "/v1/merchant/products/#{@product.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Product.count).to eq(0)
    end
  end

  context 'while providing invalid ID' do
    it 'should respond with not found' do
      delete "/v1/merchant/products/88", headers: @headers

      expect(response.code).to eq('404')
      expect(Product.count).to eq(1)
    end
  end
end
