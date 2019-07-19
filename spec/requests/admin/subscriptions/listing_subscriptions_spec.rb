require 'rails_helper'

RSpec.describe 'Listing subscriptions', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
  end

  context 'if there are any subscriptions' do
    it 'should list all subscriptions on the system' do
      @subscription = create(:subscription)
      @subscription2 = create(:subscription)

      get '/v1/admin/subscriptions', headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
    end
  end

  context 'if there are no subscriptions' do
    it 'should return no subscriptions on the system' do
      get '/v1/admin/subscriptions', headers: @headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['message']).to eq('no subscriptions on the system')
    end
  end
end
