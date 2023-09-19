require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe 'Associations' do
    it { should belong_to(:student).class_name('User').with_foreign_key('student_id') }
    it { should belong_to(:batch) }
    it { should belong_to(:school) }
  end

  describe 'Validations' do
    let!(:school) { create(:school) }
    let!(:course) { create(:course, school: school) }
    let!(:batch) { create(:batch, course: course) }
    let!(:student) { create(:user, school: school) }
    subject { create(:enrollment, batch: batch, student: student, school: school) }

    it { should validate_uniqueness_of(:student_id).scoped_to(:batch_id) }
    it { should validate_presence_of(:status) }
  end

  describe '.validate_status' do

    it 'should destroy for pending status' do
      subject.destroy
      expect(subject.errors.full_messages).to eq([])
    end

    it 'should not destroy for approved/rejected status' do
      subject.status = :approved
      subject.destroy
      expect(subject.errors.full_messages).to eq(['Only pending enrollment can be deleted'])
    end
  end
end
