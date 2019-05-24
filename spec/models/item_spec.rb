require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Require validations' do
    it 'should has a quantity' do
      should validate_presence_of(:quantity)
    end

    it 'should validates numericality of quantity' do
      validate_numericality_of(:quantity)
    end
  end

  describe 'Has associations' do
    it 'belongs to cart' do
      should belong_to :cart
    end

    it 'belongs to variant' do
      should belong_to(:variant)
    end
  end
end
