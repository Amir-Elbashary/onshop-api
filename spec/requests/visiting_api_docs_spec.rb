require 'rails_helper'

RSpec.describe 'Visiting API docs page', type: :request do
  before do
    get '/api'
  end

  it 'should show all APIs' do
    expect(response.code).to eq('200')
  end
end
