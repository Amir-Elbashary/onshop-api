require 'rails_helper'

RSpec.describe 'Showing product review', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    @headers = { 'X-APP-Token' => @app_token.token }
    @review = create(:review)
  end

  context 'when presenting valid review ID' do
    it 'should show this product review' do
      get "/v1/onshop/reviews/#{@review.id}", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['review']).to eq(@review.review)
      expect(response_body['rating']).to eq(@review.rating)
    end
  end


  context 'when presenting invalid review ID' do
    it 'should not return any review' do
      get "/v1/onshop/reviews/88", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
