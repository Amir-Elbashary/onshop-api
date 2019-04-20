require 'rails_helper'

RSpec.describe Category, type: :model do
	describe 'Require validations' do
    it 'should has a name' do
      should validate_presence_of(:name)
    end

    it 'should has a unique name' do
      # Processed via create action
    end
  end

  describe 'Has associations' do
    it 'has many sub categories' do
      should have_many :sub_categories
    end

    it 'belongs to parent category' do
      should belong_to(:parent).optional
    end
  end
end
