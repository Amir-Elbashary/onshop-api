require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'Has associations' do
    # it 'has many entries/items' do
    #   should have_many :
    # end

    it 'belongs to user' do
      should belong_to(:user)
    end
  end
end
