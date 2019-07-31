require 'rails_helper'

RSpec.describe 'Deleting discounts as a merchant', type: :request do
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

  context 'while providing product IDs which belongs to the same merchant' do
    it 'should delete that product/s discount' do
      params = { 'discount[product_ids]' => @merchant.products.pluck(:id) }

      expect(@merchant.discounts.count).to eq(2)
      expect(Discount.count).to eq(3)

      delete "/v1/merchant/discounts/id", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(@merchant.discounts.count).to eq(0)
      expect(Discount.count).to eq(1)
    end
  end

  context 'while providing product IDs which does not belong to the same merchant' do
    it 'should not delete that product/s discount' do
      params = { 'discount[product_ids]' => Product.pluck(:id) }

      expect(@merchant.discounts.count).to eq(2)
      expect(Discount.count).to eq(3)

      delete "/v1/merchant/discounts/id", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(@merchant.discounts.count).to eq(2)
      expect(Discount.count).to eq(3)
    end
  end

  context 'while providing invalid product ID' do
    it 'should respond with not found' do
      params = { 'discount[product_ids]' => [Product.first.id, 8888] }

      expect(@merchant.discounts.count).to eq(2)
      expect(Discount.count).to eq(3)

      delete "/v1/merchant/discounts/id", headers: @headers, params: params

      expect(response.code).to eq('404')
      expect(@merchant.discounts.count).to eq(2)
      expect(Discount.count).to eq(3)
    end
  end
end
