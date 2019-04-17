require 'rails_helper'

RSpec.describe 'Accessing API with wrong token', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
  end

  it 'should respond with unauthorized access' do
    headers = { 'X-APP-Token' => 'wrong token' }
    params = { 'admin[email]' => @admin.email, 'admin[password]' => @admin.password }

    post '/api/v1/admin/sessions.json', headers: headers, params: params

    expect(response.code).to eq('401')
  end
end
