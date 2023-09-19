require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'Associations' do
    it { should have_many(:batches).dependent(:destroy) }
    it { should belong_to(:school) }
  end

  describe 'Validations' do
    let!(:school) { create(:school) }
    subject { create(:course, school: school) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:years) }
  end
end
