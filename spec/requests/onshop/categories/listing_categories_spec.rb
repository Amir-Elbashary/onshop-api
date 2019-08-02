require 'rails_helper'

RSpec.describe 'Listing categories', type: :request do
  before do
    @app_token = create(:app_token)
    @headers = { 'X-APP-Token' => @app_token.token }

    @category1 = create(:category)
    @cat1_sub1 = create(:category, parent: @category1)
    @cat1_sub1_product = create(:product, category: @cat1_sub1)
    @cat1_sub1_product_variant1 = create(:variant, product: @cat1_sub1_product)
    @cat1_sub1_product_variant2 = create(:variant, product: @cat1_sub1_product)
    @cat1_sub2 = create(:category, parent: @category1)
    @cat1_sub2_product = create(:product, category: @cat1_sub2)
    @cat1_sub2_product_variant = create(:variant, product: @cat1_sub2_product)

    @category2 = create(:category)
    @cat2_sub1 = create(:category, parent: @category2)
    @cat2_sub2 = create(:category, parent: @category2)
  end

  context 'while leaving category id blank' do
    it 'should list all categories and their childs' do
      get '/v1/onshop/categories', headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
      expect(response_body[0]['variants']).to eq(3)
      expect(response_body[0]['sub_categories'][0]['variants']).to eq(2)
      expect(response_body[0]['sub_categories'][1]['variants']).to eq(1)

      expect(response_body[1]['variants']).to eq(0)
      expect(response_body[1]['sub_categories'][0]['variants']).to eq(0)
      expect(response_body[1]['sub_categories'][1]['variants']).to eq(0)
    end
  end

  context 'when providing category id' do
    it 'should return this category and it\'s childs (case of existing products)' do
      params = { category_id: @category1.id }

      get '/v1/onshop/categories', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['id']).to eq(@category1.id)
      expect(response_body['sub_categories'][0]['id']).to eq(@cat1_sub1.id)
      expect(response_body['sub_categories'][1]['id']).to eq(@cat1_sub2.id)

      expect(response_body['variants']).to eq(3)
      expect(response_body['sub_categories'][0]['variants']).to eq(2)
      expect(response_body['sub_categories'][1]['variants']).to eq(1)
    end

    it 'should return this category and it\'s childs (case of 0 products)' do
      params = { category_id: @category2.id }

      get '/v1/onshop/categories', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['id']).to eq(@category2.id)
      expect(response_body['sub_categories'][0]['id']).to eq(@cat2_sub1.id)
      expect(response_body['sub_categories'][1]['id']).to eq(@cat2_sub2.id)

      expect(response_body['variants']).to eq(0)
      expect(response_body['sub_categories'][0]['variants']).to eq(0)
      expect(response_body['sub_categories'][1]['variants']).to eq(0)
    end
  end

  context 'when providing invalid category id' do
    it 'should return 404 error' do
      params = { category_id: 88 }

      get '/v1/onshop/categories', headers: @headers, params: params

      expect(response.code).to eq('404')
    end
  end
end
