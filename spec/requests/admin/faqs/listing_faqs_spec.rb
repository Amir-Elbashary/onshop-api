require 'rails_helper'

RSpec.describe 'Listing FAQs', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @faq1 = create(:faq)
    @faq2 = create(:faq)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
  end

  context 'when presenting valid admin token' do
    it 'should list all FAQs' do
      get '/v1/admin/faqs', headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
    end
  end

  context 'when presenting invalid admin token' do
    it 'should return unauthorized' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }
      get '/v1/admin/faqs', headers: headers

      expect(response.code).to eq('401')
    end
  end
end
