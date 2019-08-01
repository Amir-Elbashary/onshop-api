require 'rails_helper'

RSpec.describe 'Creating coupon as an admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'with valid data' do
    it 'should create an offer that is assigned for one or multiple categories' do
      params = { 'coupon[percentage]' => 10,
                 'coupon[starts_at]' => Time.zone.now,
                 'coupon[ends_at]' => (Time.zone.now + 2.days) }

      post '/v1/admin/coupons', headers: @headers, params: params

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['id']).to eq(Coupon.first.id)
      expect(Coupon.count).to eq(1)
      expect(Coupon.first.percentage).to eq(10)
      expect(Coupon.first.active?).to eq(true)
    end
  end

  context 'with invalid data' do
    it 'should not create an offer without percentage' do
      params = { 'coupon[percentage]' => '',
                 'coupon[starts_at]' => Time.zone.now,
                 'coupon[ends_at]' => (Time.zone.now + 2.days) }

      post '/v1/admin/coupons', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Coupon.count).to eq(0)
    end

    it 'should not create an offer without start date' do
      params = { 'coupon[percentage]' => 10,
                 'coupon[starts_at]' => '',
                 'coupon[ends_at]' => (Time.zone.now + 2.days) }

      post '/v1/admin/coupons', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Coupon.count).to eq(0)
    end

    it 'should not create an offer without end date' do
      params = { 'coupon[percentage]' => 10,
                 'coupon[starts_at]' => Time.zone.now,
                 'coupon[ends_at]' => '' }
      
      post '/v1/admin/coupons', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Coupon.count).to eq(0)
    end

    it 'should not create an offer with end date which is before start date' do
      params = { 'coupon[percentage]' => 10,
                 'coupon[starts_at]' => Time.zone.now,
                 'coupon[ends_at]' => (Time.zone.now - 2.days) }

      post '/v1/admin/coupons', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Coupon.count).to eq(0)
    end
  end
end
