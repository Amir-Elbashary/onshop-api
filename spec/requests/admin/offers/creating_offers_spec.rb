require 'rails_helper'

RSpec.describe 'Creating offer as an admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @parent_category = create(:category)
    @sub_category1 = create(:category, parent_id: @parent_category.id)
    @sub_category2 = create(:category, parent_id: @parent_category.id)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'with valid data' do
    it 'should create an offer that is assigned for one or multiple categories' do
      params = { 'offer[category_ids]' => @parent_category.children.pluck(:id),
                 'offer[percentage]' => 10,
                 'offer[starts_at]' => Time.zone.now,
                 'offer[ends_at]' => (Time.zone.now + 2.days),
                 'offer[force]' => 'false' }

      post '/v1/admin/offers', headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Offer.count).to eq(2)
      expect(@sub_category1.offer.percentage).to eq(10)
      expect(@sub_category2.offer.percentage).to eq(10)
      expect(@sub_category1.offer.active?).to eq(true)
      expect(@sub_category2.offer.active?).to eq(true)
    end

    it 'should return a category already have offer if "Force" is unchecked' do
      create(:offer, category: @sub_category1)

      params = { 'offer[category_ids]' => @parent_category.children.pluck(:id),
                 'offer[percentage]' => 10,
                 'offer[starts_at]' => Time.zone.now,
                 'offer[ends_at]' => (Time.zone.now + 2.days),
                 'offer[force]' => 'false' }

      post '/v1/admin/offers', headers: @headers, params: params

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('422')
      expect(response_body['message']).to eq('a category already have an offer')
      expect(response_body['category_id']).to eq(@sub_category1.id)
      expect(Offer.count).to eq(1)
    end

    it 'should force update existing offer if "Force" is checked' do
      create(:offer, category: @sub_category1, percentage: 5)

      expect(Offer.count).to eq(1)
      expect(Category.find(@sub_category1.id).offer.percentage).to eq(5)
      expect(Category.find(@sub_category2.id).offer).to eq(nil)

      params = { 'offer[category_ids]' => @parent_category.children.pluck(:id),
                 'offer[percentage]' => 10,
                 'offer[starts_at]' => Time.zone.now,
                 'offer[ends_at]' => (Time.zone.now + 2.days),
                 'offer[force]' => 'true' }

      post '/v1/admin/offers', headers: @headers, params: params

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(Offer.count).to eq(2)
      expect(Category.find(@sub_category1.id).offer.percentage).to eq(10)
      expect(Category.find(@sub_category2.id).offer.percentage).to eq(10)
    end
  end

  context 'with invalid data' do
    it 'should not create an offer with invalid category ID' do
      params = { 'offer[category_ids]' => [@sub_category1.id, 8888],
                 'offer[percentage]' => 10,
                 'offer[starts_at]' => Time.zone.now,
                 'offer[ends_at]' => (Time.zone.now + 2.days),
                 'offer[force]' => 'false' }

      post '/v1/admin/offers', headers: @headers, params: params

      expect(response.code).to eq('404')
      expect(Offer.count).to eq(0)
    end

    it 'should not create an offer without percentage' do
      params = { 'offer[category_ids]' => @parent_category.children.pluck(:id),
                 'offer[percentage]' => '',
                 'offer[starts_at]' => Time.zone.now,
                 'offer[ends_at]' => (Time.zone.now + 2.days),
                 'offer[force]' => 'false' }

      post '/v1/admin/offers', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Offer.count).to eq(0)
    end

    it 'should not create an offer without start date' do
      params = { 'offer[category_ids]' => @parent_category.children.pluck(:id),
                 'offer[percentage]' => 10,
                 'offer[starts_at]' => '',
                 'offer[ends_at]' => (Time.zone.now + 2.days),
                 'offer[force]' => 'false' }

      post '/v1/admin/offers', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Offer.count).to eq(0)
    end

    it 'should not create an offer without end date' do
      params = { 'offer[category_ids]' => @parent_category.children.pluck(:id),
                 'offer[percentage]' => 10,
                 'offer[starts_at]' => Time.zone.now,
                 'offer[ends_at]' => '',
                 'offer[force]' => 'false' }
      
      post '/v1/admin/offers', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Offer.count).to eq(0)
    end

    it 'should not create an offer with end date which is before start date' do
      params = { 'offer[category_ids]' => @parent_category.children.pluck(:id),
                 'offer[percentage]' => 10,
                 'offer[starts_at]' => Time.zone.now,
                 'offer[ends_at]' => (Time.zone.now - 2.days),
                 'offer[force]' => 'false' }

      post '/v1/admin/offers', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Offer.count).to eq(0)
    end

    it 'should not create an offer with invalid force param' do
      params = { 'offer[category_ids]' => @parent_category.children.pluck(:id),
                 'offer[percentage]' => 10,
                 'offer[starts_at]' => Time.zone.now,
                 'offer[ends_at]' => (Time.zone.now - 2.days),
                 'offer[force]' => '' }

      post '/v1/admin/offers', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Offer.count).to eq(0)
    end
  end
end
