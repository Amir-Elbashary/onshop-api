require 'rails_helper'

RSpec.describe 'Listing products', type: :request do
  before do
    @app_token = create(:app_token)
    @headers = { 'X-APP-Token' => @app_token.token }
    @category = create(:category)
    @sub_category1 = create(:category, parent: @category)
    @sub_category2 = create(:category, parent: @category)

    @sub1_product1 = create(:product, category: @sub_category1)
    @variant1 = create(:variant, product: @sub1_product1, price: 100)

    @sub1_product2 = create(:product, category: @sub_category1)
    @variant2 = create(:variant, product: @sub1_product2, price: 200)

    @sub2_product1 = create(:product, category: @sub_category2)
    @variant3 = create(:variant, product: @sub2_product1, price: 300)

    @sub2_product2 = create(:product, category: @sub_category2)
    @variant4 = create(:variant, product: @sub2_product2, price: 400)

    @other_product = create(:product)
    @variant5 = create(:variant, product: @other_product, price: 500)
  end

  context 'when presenting valid app token' do
    it 'should list all products per pages' do
      params = { page: 1 }

      get '/v1/onshop/products', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['products'].count).to eq(5)
      expect(response_body['products'][0]['variants'][0]['price'].to_f).to eq(@variant1.price)
      expect(response_body['products'][0]['variants'][0]['old_price'].to_f).to eq(@variant1.price)
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
        expect(response_body['products'].count).to eq(2)
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
      expect(response_body['products'].count).to eq(2)
    end
  end

  describe 'when presenting price range' do
    context 'if it\'s invalid range' do
      it 'should return error message' do
        params = { price: '200' }

        get '/v1/onshop/products', headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('422')
      end
    end

    context 'if it\'s valid range' do
      it 'should filter products within given range' do
        params = { price: '200,400' }

        get '/v1/onshop/products', headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body['products'].count).to eq(3)
      end
    end
  end

  context 'when having discount for a product' do
    it 'should list price after discount and old price' do
      create(:discount, merchant: @variant1.product.merchant, product: @variant1.product, percentage: 10)
      params = { page: 1 }

      get '/v1/onshop/products', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['products'].count).to eq(5)
      expect(response_body['products'][0]['variants'][0]['price'].to_f).to eq(90.0)
      expect(response_body['products'][0]['variants'][0]['old_price']).to eq('100.0')
    end
  end

  context 'when having offer for a product category' do
    it 'should list price after discounting offer and old price' do
      create(:offer, category: @variant1.product.category, percentage: 20)
      params = { page: 1 }

      get '/v1/onshop/products', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['products'].count).to eq(5)
      expect(response_body['products'][0]['variants'][0]['price'].to_f).to eq(80.0)
      expect(response_body['products'][0]['variants'][0]['old_price']).to eq('100.0')
    end
  end

  context 'when having offer and discount for a product category' do
    it 'should list price after discounting offer and old price' do
      create(:offer, category: @variant1.product.category, percentage: 20)
      create(:discount, merchant: @variant1.product.merchant, product: @variant1.product, percentage: 10)
      params = { page: 1 }

      get '/v1/onshop/products', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      variant_price = response_body['products'][0]['variants'][0]['price']
      price_after_discount = variant_price.to_f - (Offer.first.percentage / 100)

      expect(response.code).to eq('200')
      expect(response_body['products'].count).to eq(5)
      expect(response_body['products'][0]['variants'][0]['price'].to_f).to eq(80.0)
      expect(response_body['products'][0]['variants'][0]['old_price']).to eq('100.0')
    end
  end

  context 'when having expired offer for a product category' do
    it 'should list same price after discounting offer and old price' do
      create(:offer, category: @variant1.product.category,
                     percentage: 20,
                     starts_at: (Time.zone.now - 4.days),
                     ends_at: (Time.zone.now - 2.days))
      params = { page: 1 }

      get '/v1/onshop/products', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['products'].count).to eq(5)
      expect(response_body['products'][0]['variants'][0]['price'].to_f).to eq(100.0)
      expect(response_body['products'][0]['variants'][0]['old_price']).to eq('100.0')
    end
  end
end
