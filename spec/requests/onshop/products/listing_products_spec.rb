require 'rails_helper'

RSpec.describe 'Listing products', type: :request do
  before do
    @app_token = create(:app_token)
    @headers = { 'X-APP-Token' => @app_token.token }
    @category = create(:category)
    @sub_category1 = create(:category, parent: @category)
    @sub_category2 = create(:category, parent: @category)
    @sub1_product1 = create(:product, category: @sub_category1)
    @sub1_product2 = create(:product, category: @sub_category1)
    @sub2_product1 = create(:product, category: @sub_category2)
    @sub2_product2 = create(:product, category: @sub_category2)
    @other_product = create(:product)
  end

  context 'when presenting valid app token' do
    it 'should list all products per pages' do
      params = { page: 1 }

      get '/v1/onshop/products', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['products'].count).to eq(5)
    end
  end

  describe 'when provding category ID' do
    context 'if it\'s valid parent category id' do
      it 'should return this category\'s sub categories products' do
        params = { category_id: @category.id }

        get '/v1/onshop/products', headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body['products'].count).to eq(4)
      end
    end

    context 'if it\'s valid sub category id' do
      it 'should return this sub category products' do
        params = { category_id: @sub_category1.id }

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
