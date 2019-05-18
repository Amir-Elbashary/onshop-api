require 'rails_helper'

RSpec.describe 'Creating merchant by admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
  end

  context 'with valid data' do
    it 'should create new admin' do
      params = { 'merchant[email]' => 'merchant@onshop.com',
                 'merchant[password]' => '12345678',
                 'merchant[password_confirmation]' => '12345678',
                 'merchant[first_name]' => 'OnShop',
                 'merchant[last_name]' => 'Merchant' }

      post '/v1/admin/merchants', headers: @headers, params: params

      expect(response.code).to eq('201')
      expect(Merchant.first.email).to eq('merchant@onshop.com')
      expect(Merchant.first.full_name).to eq('OnShop Merchant')
    end
  end

  context 'with invalid data' do
    it 'should not create new merchant' do
      params = { 'merchant[email]' => 'merchant',
                 'merchant[password]' => '12345678',
                 'merchant[password_confirmation]' => '12345678',
                 'merchant[first_name]' => 'OnShop',
                 'merchant[last_name]' => 'Merchant' }

      post '/v1/admin/merchants', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Merchant.count).to eq(0)
    end
  end

  context 'with duplicated data' do
    it 'should not create new merchant' do
      @merchant = create(:merchant)

      params = { 'merchant[email]' => @merchant.email,
                 'merchant[password]' => '12345678',
                 'merchant[password_confirmation]' => '12345678',
                 'merchant[first_name]' => 'OnShop',
                 'merchant[last_name]' => 'Merchant' }

      post '/v1/admin/merchants', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Merchant.count).to eq(1)
    end
  end
end
