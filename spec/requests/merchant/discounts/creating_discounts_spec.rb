require 'rails_helper'

RSpec.describe 'Creating discount as a merchant', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant_with_logins)
    @product1 = create(:product, merchant: @merchant)
    @product2 = create(:product, merchant: @merchant)
    @others_product = create(:product)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.logins.first.token }
  end

  context 'with valid data' do
    it 'should create a discount that is assigned for one or multiple products' do
      params = { 'discount[merchant_id]' => @merchant.id,
                 'discount[product_ids]' => @merchant.products.pluck(:id),
                 'discount[percentage]' => 10,
                 'discount[starts_at]' => Time.zone.now,
                 'discount[ends_at]' => (Time.zone.now + 2.days),
                 'discount[force]' => 'false' }

      post '/v1/merchant/discounts', headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Discount.count).to eq(2)
      expect(@product1.discount.percentage).to eq(10)
      expect(@product2.discount.percentage).to eq(10)
      expect(@product1.discount.active?).to eq(true)
      expect(@product2.discount.active?).to eq(true)
    end

    it 'should return a product already have discount if "Force" is unchecked' do
      create(:discount, merchant: @merchant, product: @product2)

      params = { 'discount[merchant_id]' => @merchant.id,
                 'discount[product_ids]' => @merchant.products.pluck(:id),
                 'discount[percentage]' => 10,
                 'discount[starts_at]' => Time.zone.now,
                 'discount[ends_at]' => (Time.zone.now + 2.days),
                 'discount[force]' => 'false' }

      post '/v1/merchant/discounts', headers: @headers, params: params

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('422')
      expect(response_body['message']).to eq('a product already have a discount')
      expect(response_body['product_id']).to eq(@product2.id)
      expect(Discount.count).to eq(1)
    end

    it 'should force update existing discount if "Force" is checked' do
      @product3 = create(:product, merchant: @merchant)
      create(:discount, merchant: @merchant, product: @product1, percentage: 5)
      create(:discount, merchant: @merchant, product: @product2, percentage: 4)

      expect(Discount.count).to eq(2)
      expect(@merchant.products.count).to eq(3)
      expect(Product.find(@product1.id).discount.percentage).to eq(5)
      expect(Product.find(@product2.id).discount.percentage).to eq(4)
      expect(Product.find(@product3.id).discount).to eq(nil)

      params = { 'discount[merchant_id]' => @merchant.id,
                 'discount[product_ids]' => @merchant.products.pluck(:id),
                 'discount[percentage]' => 10,
                 'discount[starts_at]' => Time.zone.now,
                 'discount[ends_at]' => (Time.zone.now + 2.days),
                 'discount[force]' => 'true' }

      post '/v1/merchant/discounts', headers: @headers, params: params

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(Product.find(@product1.id).discount.percentage).to eq(10)
      expect(Product.find(@product2.id).discount.percentage).to eq(10)
      expect(Product.find(@product3.id).discount.percentage).to eq(10)
      expect(Discount.count).to eq(3)
    end

    it 'should return product x does not belong to this merchant if other merchant product is used' do
      params = { 'discount[merchant_id]' => @merchant.id,
                 'discount[product_ids]' => Product.pluck(:id),
                 'discount[percentage]' => 10,
                 'discount[starts_at]' => Time.zone.now,
                 'discount[ends_at]' => (Time.zone.now + 2.days),
                 'discount[force]' => 'false' }

      post '/v1/merchant/discounts', headers: @headers, params: params

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('422')
      expect(response_body['message']).to eq("a product does not belong to this merchant")
      expect(Discount.count).to eq(0)
    end
  end

  context 'with invalid data' do
    it 'should not create a discount with invalid product ID' do
      params = { 'discount[merchant_id]' => @merchant.id,
                 'discount[product_ids]' => [Product.first.id, 8888],
                 'discount[percentage]' => 10,
                 'discount[starts_at]' => Time.zone.now,
                 'discount[ends_at]' => (Time.zone.now + 2.days),
                 'discount[force]' => 'false' }

      post '/v1/merchant/discounts', headers: @headers, params: params

      expect(response.code).to eq('404')
      expect(Discount.count).to eq(0)
    end

    it 'should not create a discount without percentage' do
      params = { 'discount[merchant_id]' => @merchant.id,
                 'discount[product_ids]' => @merchant.products.pluck(:id),
                 'discount[percentage]' => '',
                 'discount[starts_at]' => Time.zone.now,
                 'discount[ends_at]' => (Time.zone.now + 2.days),
                 'discount[force]' => 'false' }

      post '/v1/merchant/discounts', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Discount.count).to eq(0)
    end

    it 'should not create a discount without start date' do
      params = { 'discount[merchant_id]' => @merchant.id,
                 'discount[product_ids]' => @merchant.products.pluck(:id),
                 'discount[percentage]' => 10,
                 'discount[starts_at]' => '',
                 'discount[ends_at]' => (Time.zone.now + 2.days),
                 'discount[force]' => 'false' }

      post '/v1/merchant/discounts', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Discount.count).to eq(0)
    end

    it 'should not create a discount without end date' do
      params = { 'discount[merchant_id]' => @merchant.id,
                 'discount[product_ids]' => @merchant.products.pluck(:id),
                 'discount[percentage]' => 10,
                 'discount[starts_at]' => Time.zone.now,
                 'discount[ends_at]' => '',
                 'discount[force]' => 'false' }

      post '/v1/merchant/discounts', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Discount.count).to eq(0)
    end

    it 'should not create a discount with end date which is before start date' do
      params = { 'discount[merchant_id]' => @merchant.id,
                 'discount[product_ids]' => @merchant.products.pluck(:id),
                 'discount[percentage]' => 10,
                 'discount[starts_at]' => Time.zone.now,
                 'discount[ends_at]' => (Time.zone.now - 2.days),
                 'discount[force]' => 'false' }

      post '/v1/merchant/discounts', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Discount.count).to eq(0)
    end

    it 'should not create a discount with invalid force param' do
      params = { 'discount[merchant_id]' => @merchant.id,
                 'discount[product_ids]' => @merchant.products.pluck(:id),
                 'discount[percentage]' => '10',
                 'discount[starts_at]' => Time.zone.now,
                 'discount[ends_at]' => (Time.zone.now + 2.days),
                 'discount[force]' => '' }

      post '/v1/merchant/discounts', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Discount.count).to eq(0)
    end
  end
end
