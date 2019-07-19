require 'rails_helper'

RSpec.describe 'Deleting merchant by admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
    @merchant = create(:merchant)
  end

  context 'with valid ID presented' do
    it 'should delete the merchant permanently' do
      expect(Merchant.count).to eq(1)

      delete "/v1/admin/merchants/#{@merchant.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Merchant.count).to eq(0)
    end
  end

  context 'with invalid ID presented' do
    it 'should respond with unprocessable entity' do
      expect(Merchant.count).to eq(1)

      delete "/v1/admin/merchants/88", headers: @headers

      expect(response.code).to eq('404')
      expect(Merchant.count).to eq(1)
    end
  end
end
