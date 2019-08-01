require 'rails_helper'

RSpec.describe 'Deleting coupons as an admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @coupon = create(:coupon)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'while providing valid coupon ID' do
    it 'should delete that coupon' do
      expect(Coupon.count).to eq(1)
      expect(@coupon.code).not_to eq(nil)

      delete "/v1/admin/coupons/#{@coupon.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Coupon.count).to eq(0)
    end
  end

  context 'while providing invalid coupon ID' do
    it 'should respond with not found' do
      expect(Coupon.count).to eq(1)

      delete "/v1/admin/coupons/8888", headers: @headers

      expect(response.code).to eq('404')
      expect(Coupon.count).to eq(1)
    end
  end
end
