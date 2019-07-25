require 'rails_helper'

RSpec.describe 'Deleting FAQ', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @faq = create(:faq)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'while providing valid FAQ ID' do
    it 'should delete that FAQ' do
      delete "/v1/admin/faqs/#{@faq.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Faq.count).to eq(0)
    end
  end

  context 'while providing invalid FAQ ID' do
    it 'should respond with not found' do
      delete "/v1/admin/faqs/8888", headers: @headers

      expect(response.code).to eq('404')
      expect(Faq.count).to eq(1)
    end
  end
end
