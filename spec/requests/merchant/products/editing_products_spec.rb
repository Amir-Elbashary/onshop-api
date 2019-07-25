require 'rails_helper'

RSpec.describe 'Editing products by merchant', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.logins.first.token }
    @category = create(:category)
    @sub_category = create(:category, parent_id: @category.id)
    @merchant_product = create(:product, merchant: @merchant)
    @others_product = create(:product)
  end

  context 'editing owned product with valid data' do
    it 'should update with unique name' do
      params = { 'product[category_id]' => @sub_category.id,
                 'product[name_en]' => 'New product name',
                 'product[name_ar]' => 'New product arabic name',
                 'product[description_en]' => 'This is new product',
                 'product[image]' => '' }

      put "/v1/merchant/products/#{@merchant_product.id}", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(@merchant.products.first.name_en).to eq('New product name')
      expect(@merchant.products.first.name_ar).to eq('New product arabic name')
    end

    it 'should not update with duplicated name for the same merchant' do
      @product = create(:product, name: 'Specific name', merchant: @merchant)
      params = { 'product[category_id]' => @sub_category.id,
                 'product[name_en]' => @product.name,
                 'product[description_en]' => 'This is new product',
                 'product[image]' => '' }

      put "/v1/merchant/products/#{@merchant_product.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(@merchant.products.first.name).to eq(@merchant_product.name)
    end
  end

  context 'editing owned product with invalid data' do
    it 'should not update product info' do
      params = { 'product[category_id]' => @sub_category.id,
                 'product[name_en]' => '',
                 'product[description_en]' => 'This is new product',
                 'product[image]' => '' }

      put "/v1/merchant/products/#{@merchant_product.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(@merchant.products.first.name).to eq(@merchant_product.name)
    end
  end

  context 'attempting to edit others product' do
    it 'should not allow to edit the product info' do
      params = { 'product[category_id]' => @sub_category.id,
                 'product[name_en]' => 'New product name',
                 'product[description_en]' => 'This is new product',
                 'product[image]' => '' }

      put "/v1/merchant/products/#{@others_product.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Product.where.not(merchant_id: @merchant.id).first.name).to eq(@others_product.name)
    end
  end
end
