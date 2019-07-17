require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Require validations' do
    it 'should has total_items' do
      should validate_presence_of(:total_items)
    end

    it 'should has total_price' do
      should validate_presence_of(:total_price)
    end

    it 'should validates numericality of total items' do
      validate_numericality_of(:total_items)
    end

    it 'should validates numericality of total price' do
      validate_numericality_of(:total_price)
    end
  end

  describe 'Has associations' do
    it 'belongs to user' do
      should belong_to(:user)
    end

    it 'belongs to cart' do
      should belong_to(:cart)
    end
  end
end
