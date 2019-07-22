require 'rails_helper'

RSpec.describe 'Creating FAQs as Admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
  end

  context 'with valid data' do
    it 'should create a new FAQ' do
      params = { 'faq[question_en]' => 'Simple english question',
                 'faq[question_ar]' => 'Simple arabic question',
                 'faq[answer_en]' => 'Simple english answer',
                 'faq[answer_ar]' => 'Simple arabic answer' }

      post '/v1/admin/faqs', headers: @headers, params: params

      expect(Faq.first.question_en).not_to eq(Faq.first.question_ar)
      expect(response.code).to eq('200')
      expect(Faq.count).to eq(1)
    end
  end

  context 'with invalid data' do
    it 'should not create a product' do
      params = { 'faq[question_en]' => 'Simple english question',
                 'faq[question_ar]' => 'Simple arabic question',
                 'faq[answer_en]' => '',
                 'faq[answer_ar]' => 'Simple arabic answer' }

      post '/v1/admin/faqs', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Faq.count).to eq(0)
    end
  end
end
