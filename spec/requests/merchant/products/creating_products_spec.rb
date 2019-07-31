require 'rails_helper'

RSpec.describe 'Creating products as merchant', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant_with_logins)
    @category = create(:category)
    @sub_category = create(:category, parent_id: @category.id)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.logins.first.token }
  end

  context 'with valid data' do
    it 'should create a product' do
      params = { 'product[merchant_id]' => @merchant.id,
                 'product[category_id]' => @sub_category.id,
                 'product[name_en]' => 'New product',
                 'product[name_ar]' => 'Arabic Name',
                 'product[description_en]' => 'This is new product',
                 'product[image]' => '' }

      post '/v1/merchant/products', headers: @headers, params: params

      expect(Product.first.name_en).not_to eq(Product.first.name_ar)
      expect(response.code).to eq('201')
      expect(Product.count).to eq(1)
    end
  end

  context 'with invalid data' do
    it 'should not create a product' do
      params = { 'product[merchant_id]' => @merchant.id,
                 'product[category_id]' => '',
                 'product[name_en]' => 'New product',
                 'product[description_en]' => 'This is new product',
                 'product[image]' => '' }

      post '/v1/merchant/products', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Product.count).to eq(0)
    end
  end

  context 'with duplicated data' do
    it 'should not create a product' do
      @product = create(:product, name: 'helmet', merchant_id: @merchant.id)

      params = { 'product[merchant_id]' => @merchant.id,
                 'product[category_id]' => @sub_category.id,
                 'product[name_en]' => 'helmet',
                 'product[description_en]' => 'This is new product',
                 'product[image]' => '' }

      post '/v1/merchant/products', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Product.count).to eq(1)
    end
  end
end
