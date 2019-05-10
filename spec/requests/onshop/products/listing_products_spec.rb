require 'rails_helper'

RSpec.describe 'Listing products', type: :request do
  before do
    @app_token = create(:app_token)
    @headers = { 'X-APP-Token' => @app_token.token }
    @category1 = create(:category)
    @category2 = create(:category)
    @cat1_product1 = create(:product, category: @category1)
    @cat1_product1 = create(:product, category: @category1)
    @cat2_product1 = create(:product, category: @category2)
    @cat2_product2 = create(:product, category: @category2)
    @other_product = create(:product)
  end

  context 'when presenting valid app token' do
    it 'should list all products per pages' do
      params = { page: 1 }

      get '/v1/onshop/products', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(5)
    end
  end

  describe 'when provding category ID' do
    context 'if it\'s valid category id' do
      it 'should return this category products' do
        params = { category_id: @category1.id }

        get '/v1/onshop/products', headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body.count).to eq(2)
      end
    end

    context 'if it\'s invalid category id' do
      it 'should return 404 error' do
        params = { category_id: 88 }

        get '/v1/onshop/products', headers: @headers, params: params

        expect(response.code).to eq('404')
      end
    end
  end

  context 'when searching by name' do
    it 'should list all products contains that name' do
      @product1 = create(:product, name: 'A New product')
      @product2 = create(:product, name: 'Another nEw product')

      params = { search: 'new' }

      get '/v1/onshop/products', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
    end
  end
end
