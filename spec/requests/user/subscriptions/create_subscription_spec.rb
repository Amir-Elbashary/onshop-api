require 'rails_helper'

RSpec.describe 'Creating subscription', type: :request do
  before do
    @app_token = create(:app_token)
    @headers = { 'X-APP-Token' => @app_token.token }
  end

  describe 'with valid email' do
    context 'while providing unique email' do
      it 'should create new subscription' do
        params = { 'subscription[email]' => 'user@example.com' }

        post "/v1/user/subscriptions", headers: @headers, params: params

        expect(response.code).to eq('201')
        expect(Subscription.first.email).to eq('user@example.com')
        expect(Subscription.first.status).to eq('active')
      end
    end

    context 'while providing existing email' do
      it 'should not create new subscription' do
        @subscription = create(:subscription)

        params = { 'subscription[email]' => @subscription.email.upcase }

        post "/v1/user/subscriptions", headers: @headers, params: params

        expect(response.code).to eq('422')
        expect(Subscription.first.email).to eq(@subscription.email)
        expect(Subscription.count).to eq(1)
      end
    end
  end

  describe 'with invalid email' do
    it 'should not create new subscription' do
      params = { 'subscription[email]' => 'example.com' }

      post "/v1/user/subscriptions", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Subscription.count).to eq(0)
    end
  end
end
