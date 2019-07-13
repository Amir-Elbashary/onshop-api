require 'rails_helper'

RSpec.describe 'Toggling', type: :request do
  before do
    @app_token = create(:app_token)
    @headers = { 'X-APP-Token' => @app_token.token }
    @active_subscription = create(:subscription)
    @inactive_subscription = create(:subscription, status: 0)
  end

  describe 'active subscription' do
    context 'while providing existing email' do
      it 'should toggle status to inactive' do
        params = { 'subscription[email]' => @active_subscription.email }

        post "/v1/user/subscriptions/toggle", headers: @headers, params: params

        expect(response.code).to eq('200')
        expect(Subscription.active.count).to eq(0)
      end
    end

    context 'while providing non-existing email' do
      it 'should return an error' do
        params = { 'subscription[email]' => 'non_existing_email@exmaple.com' }

        post "/v1/user/subscriptions/toggle", headers: @headers, params: params

        expect(response.code).to eq('404')
        expect(Subscription.active.count).to eq(1)
      end
    end
  end

  describe 'inactive subscription' do
    context 'while providing existing email' do
      it 'should toggle status to active' do
        params = { 'subscription[email]' => @inactive_subscription.email }

        post "/v1/user/subscriptions/toggle", headers: @headers, params: params

        expect(response.code).to eq('200')
        expect(Subscription.inactive.count).to eq(0)
      end
    end

    context 'while providing non-existing email' do
      it 'should return an error' do
        params = { 'subscription[email]' => 'non_existing_email@exmaple.com' }

        post "/v1/user/subscriptions/toggle", headers: @headers, params: params

        expect(response.code).to eq('404')
        expect(Subscription.inactive.count).to eq(1)
      end
    end
  end
end
