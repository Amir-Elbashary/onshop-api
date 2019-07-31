require 'rails_helper'

RSpec.describe 'Deleting offers as an admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @parent_category = create(:category)
    @parent_offer = create(:offer, category: @parent_category)
    @sub_category1 = create(:category, parent_id: @parent_category.id)
    @parent_offer = create(:offer, category: @sub_category1)
    @sub_category2 = create(:category, parent_id: @parent_category.id)
    @parent_offer = create(:offer, category: @sub_category2)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'while providing valid category IDs' do
    it 'should delete that category/ies offer' do
      params = { 'offer[category_ids]' => @parent_category.children.pluck(:id) }

      expect(Offer.count).to eq(3)

      delete "/v1/admin/offers/id", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Offer.count).to eq(1)
    end
  end

  context 'while providing invalid product ID' do
    it 'should respond with not found' do
      params = { 'offer[category_ids]' => [@parent_category.id, 8888] }

      expect(Offer.count).to eq(3)

      delete "/v1/admin/offers/id", headers: @headers, params: params

      expect(response.code).to eq('404')
      expect(Offer.count).to eq(3)
    end
  end
end
