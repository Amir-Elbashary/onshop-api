require 'rails_helper'

RSpec.describe 'Listing coupons as an admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @coupon1 = create(:coupon)
    @coupon2 = create(:coupon)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'when presenting valid admin token' do
    it 'should list all coupons' do
      get '/v1/admin/coupons', headers: @headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
    end
  end

  context 'when presenting invalid admin token' do
    it 'should not return any tokens' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }
      get '/v1/admin/coupons', headers: headers

      expect(response.code).to eq('401')
    end
  end
end
