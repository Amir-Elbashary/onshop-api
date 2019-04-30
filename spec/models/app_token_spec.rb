require 'rails_helper'

RSpec.describe AppToken, type: :model do
	describe 'Require validations' do
    it 'should has a unique title' do
      should validate_uniqueness_of(:title).case_insensitive
    end
  end
end
