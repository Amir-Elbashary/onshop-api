require 'rails_helper'

RSpec.describe 'Editing FAQ by admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @faq = create(:faq)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'with valid data' do
    it 'should update the FAQ' do
      params = { 'faq[question_en]' => 'Simple english question',
                 'faq[question_ar]' => 'Simple arabic question',
                 'faq[answer_en]' => 'Simple english answer',
                 'faq[answer_ar]' => 'Simple arabic answer' }

      put "/v1/admin/faqs/#{@faq.id}", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Faq.first.question_en).to eq('Simple english question')
      expect(Faq.first.answer_en).to eq('Simple english answer')
    end
  end

  context 'with invalid data' do
    it 'should not update the FAQ' do
      params = { 'faq[question_en]' => '',
                 'faq[question_ar]' => 'Simple arabic question',
                 'faq[answer_en]' => 'Simple english answer',
                 'faq[answer_ar]' => 'Simple arabic answer' }

      put "/v1/admin/faqs/#{@faq.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Faq.first.question_en).to eq(@faq.question_en)
    end
  end
end
