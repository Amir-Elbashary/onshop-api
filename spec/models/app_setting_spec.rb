require 'rails_helper'

RSpec.describe AppSetting, type: :model do
  describe 'Require validations' do
    it 'should has a name' do
      should validate_presence_of(:name_en)
    end
  end
end
