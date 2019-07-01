require 'rails_helper'

RSpec.describe 'Creating product review as user', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.authentication_token }
    @review1 = create(:review, user: @user)
    @review2 = create(:review, user: @user)
  end

  context 'with valid user token' do
    it 'should create a product review' do
      get '/v1/user/reviews', headers: @headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.size).to eq(2)
    end
  end
end
