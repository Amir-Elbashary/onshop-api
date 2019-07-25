require 'rails_helper'

RSpec.describe 'Toggling contact status', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @contact = create(:contact, status: 1)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'closing opened contact' do
    it 'should mark it as closed' do
      post "/v1/admin/contacts/#{@contact.id}/toggle", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(Contact.first.close?).to eq(true)
      expect(response_body['status']).to eq('close')
    end
  end

  context 'opening closed contact' do
    it 'should mark it as opened' do
      @contact.close!
      post "/v1/admin/contacts/#{@contact.id}/toggle", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(Contact.first.open?).to eq(true)
      expect(response_body['status']).to eq('open')
    end
  end

  context 'providing invalid ID' do
    it 'should return not found' do
      post "/v1/admin/contacts/8888/toggle", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
