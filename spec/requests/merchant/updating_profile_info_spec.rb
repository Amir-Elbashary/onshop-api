require 'rails_helper'

RSpec.describe 'Updating merchant info', type: :request do
  before do
    @app_token = create(:app_token)
    @merchant = create(:merchant)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @merchant.authentication_token }
  end

  context 'with valid data' do
    it 'should update merchant info' do
      params = { 'merchant[first_name]' => 'New', 'merchant[last_name]' => 'name' }

      put "/v1/merchant/merchants/#{@merchant.id}", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Merchant.first.full_name).to eq('New name')
    end
  end

  context 'with invalid data' do
    it 'should not update merchant info' do
      params = { 'merchant[first_name]' => '', 'merchant[last_name]' => '' }

      put "/v1/merchant/merchants/#{@merchant.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Merchant.first.full_name).to eq(@merchant.full_name)
    end
  end
end
