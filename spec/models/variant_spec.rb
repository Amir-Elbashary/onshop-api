require 'rails_helper'

RSpec.describe Variant, type: :model do
  describe 'Require validations' do
    it 'should has a price' do
      should validate_presence_of(:price)
    end

    it 'should validates numericality of price' do
      validate_numericality_of(:price)
    end

    it 'should validates numericality of quantity' do
      validate_numericality_of(:quantity)
    end
  end

  describe 'Has associations' do
    it 'belongs to product' do
      should belong_to(:product)
    end
  end
end
