require 'rails_helper'

RSpec.describe 'Showing FAQ', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @faq = create(:faq)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
  end

  context 'when presenting valid FAQ ID' do
    it 'should show this FAQ' do
      get "/v1/admin/faqs/#{@faq.id}", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['id']).to eq(@faq.id)
      expect(response_body['question_en']).to eq(@faq.question_en)
    end
  end

  context 'when presenting invalid FAQ ID' do
    it 'should return not found' do
      get "/v1/admin/faqs/8888", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
