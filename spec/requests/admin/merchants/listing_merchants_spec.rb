require 'rails_helper'

RSpec.describe 'Listing merchants by admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'if there are any merchants' do
    it 'should list all merchants on the system' do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)

      get '/v1/admin/merchants', headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
    end
  end

  context 'if there are no merchants' do
    it 'should return no merchants on the system' do
      get '/v1/admin/merchants', headers: @headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['message']).to eq('no merchants on the system')
    end
  end
end
