require 'rails_helper'

RSpec.describe Batch, type: :model do
  describe 'Associations' do
    it { should belong_to(:course) }
    it { should have_many(:enrollments) }
    it { should have_many(:students).through(:enrollments).source(:student) }
  end

  describe 'Validations' do
    let!(:school) { create(:school) }
    let!(:course) { create(:course, school: school) }
    subject { create(:batch, course: course) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end
end
