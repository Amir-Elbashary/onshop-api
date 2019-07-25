require 'rails_helper'

RSpec.describe 'Toggling subscription status', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @subscription = create(:subscription, status: 1)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'deactivating subscription' do
    it 'should mark it as inactive' do
      post "/v1/admin/subscriptions/#{@subscription.id}/toggle", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(Subscription.first.inactive?).to eq(true)
      expect(response_body['status']).to eq('inactive')
    end
  end

  context 'activating subscription' do
    it 'should mark it as active' do
      @subscription.inactive!
      post "/v1/admin/subscriptions/#{@subscription.id}/toggle", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(Subscription.first.active?).to eq(true)
      expect(response_body['status']).to eq('active')
    end
  end

  context 'providing invalid ID' do
    it 'should return not found' do
      post "/v1/admin/subscriptions/8888/toggle", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
