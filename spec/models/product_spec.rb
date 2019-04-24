require 'rails_helper'

RSpec.describe Product, type: :model do
	describe 'Require validations' do
    it 'should has a name' do
      should validate_presence_of(:name_en)
    end

    it 'should has a unique name' do
      # Exists but not suppored for globalized attrs
    end
  end

  describe 'Has associations' do
    # it 'has many variants' do
    #   should have_many :variants
    # end

    it 'belongs to merchant' do
      should belong_to(:merchant)
    end

    it 'belongs to category' do
      should belong_to(:category)
    end
  end
end
