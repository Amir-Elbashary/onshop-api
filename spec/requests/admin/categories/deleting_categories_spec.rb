require 'rails_helper'

RSpec.describe 'Deleting categories', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
    @category = create(:category)
    @sub_category1 = create(:category, parent_id: @category.id)
    @sub_category2 = create(:category, parent_id: @category.id)
  end

  context 'when deleting parent category' do
    it 'should delete it\'s sub categories as well' do
      delete "/v1/admin/categories/#{@category.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Category.count).to eq(0)
    end
  end

  context 'when deleting sub category' do
    it 'should delete the selected category only' do
      delete "/v1/admin/categories/#{@sub_category1.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Category.count).to eq(2)
    end
  end

  context 'when presenting invalid ID' do
    it 'should respond with not found' do
      delete "/v1/admin/categories/88", headers: @headers

      expect(response.code).to eq('404')
      expect(Category.count).to eq(3)
    end
  end
end
