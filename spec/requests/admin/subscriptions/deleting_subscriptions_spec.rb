require 'rails_helper'

RSpec.describe 'Deleting subscriptions', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
    @subscription = create(:subscription)
  end

  context 'with valid ID presented' do
    it 'should delete the subscription permanently' do
      expect(Subscription.count).to eq(1)

      delete "/v1/admin/subscriptions/#{@subscription.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Subscription.count).to eq(0)
    end
  end

  context 'with invalid ID presented' do
    it 'should respond with unprocessable entity' do
      expect(Subscription.count).to eq(1)

      delete "/v1/admin/subscriptions/8888", headers: @headers

      expect(response.code).to eq('404')
      expect(Subscription.count).to eq(1)
    end
  end
end
